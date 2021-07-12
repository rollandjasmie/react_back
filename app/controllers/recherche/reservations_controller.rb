class Recherche::ReservationsController < ApplicationController
  before_action :authorized, only: [:all]

  #===================== réservation extratnet ==================================
  #==== recherche des réservations tous appartiennent à un logement
  def index
    reservations = Reservation.where(logement_id:params[:logement_id])
    #params de la recherche
    type=params[:type]
    debut=params[:arrivee]
    fin=params[:depart]
   #resultat de  la recherche et le nom de la voyageur
    reponses=[]
    reponseuser=[]
    if(type=="arrivee")
     reservations.each do |reservation|
        if debut != "Invalid date" && fin != "Invalid date"
          if (params[:status].present?) 
            if (reservation.arrivee >= Date.parse(debut)) && (reservation.arrivee <= Date.parse(fin) && reservation.status == params[:status])
              reponses << reservation
              reponseuser << reservation.user
            end      
          else
            if (reservation.arrivee >= Date.parse(debut)) && (reservation.arrivee <= Date.parse(fin))
              reponses << reservation
              reponseuser << reservation.user
            end
          end
        end
      end
    end
    if(type=="depart")
     reservations.each do |reservation|
      
        if (params[:status].present?)
          if (reservation.depart >= Date.parse(debut)) && (reservation.depart <= Date.parse(fin) && reservation.status == params[:status])
          reponses << reservation
          reponseuser << reservation.user
        end
      else
        if (reservation.depart >= Date.parse(debut)) && (reservation.depart <= Date.parse(fin))
          reponses << reservation
          reponseuser << reservation.user
        end
      end
      
        
      end
    end
    if reponses.present?
       render json:{
              reservation:reponses,
              reponseuser:reponseuser
        }
    else
      render json:{
        reservation:nil,
        noresultat: :pas_de_resultat
      }
    end
  end


  #============================ réservation dashboard =================================
  #==== recherche des réservations tous appartiennent à un proriétaire ou co-gestionnaire

  def all
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    user = current_user
    value = params[:recherche]
    logements = Logement.all
    #resultat
    recherche = []

    logements.each do |logement|
      if logement.user == user && logement.reservations.present?
        reservations = logement.reservations
        reservations.each do |reservation|
          if reservation.idreservation.downcase.include?(value.downcase) || reservation.logement.name.downcase.include?(value.downcase) || reservation.user.name.downcase.include?(value.downcase) || reservation.user.first_name.downcase.include?(value.downcase) 
            recherche << {logement:logement,reservation:reservation,user:reservation.user}
          end
        end
      end
      if logement.cogestion.present? && logement.cogestion.include?(user.id) && logement.reservations.present?
        reservations = logement.reservations
        reservations.each do |reservation|
          if reservation.idreservation.downcase.include?(value.downcase) || reservation.logement.name.downcase.include?(value.downcase) || reservation.user.name.downcase.include?(value.downcase) || reservation.user.first_name.downcase.include?(value.downcase) 
            recherche << {logement:logement,reservation:reservation,user:reservation.user}
          end
        end
      end
    end
    
    if recherche.present?
       render json:{
          recherche:recherche
        }
    else
        render json:{
          recherche:nil
        }
    end
  end
  
end
