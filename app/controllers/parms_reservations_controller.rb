class ParmsReservationsController < ApplicationController
  before_action :authorized, only: [:update]

   def index#affichage : parametre de la réservation
  logement = Logement.find_by(id:params[:logement_id])
  reservartion = logement.parms_reservation
     render json: {
      reservartion:reservartion
    }
  end


  def update#mis à jour : parametre de la réservation
    logement = Logement.find_by(id:params[:logement_id])
    reservartion = logement.parms_reservation
      if current_user.has_attribute?(:admin)#pour l'admin
        reservartion.update(title:params[:title],autre:params[:autre])
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - règlement intérieur", admin_run_id: current_user.id)
      else#pour propriétaire
        reservartion.update(title:params[:title],autre:params[:autre])
      end
  end
end
