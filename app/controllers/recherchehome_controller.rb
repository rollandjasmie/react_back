class RecherchehomeController < ApplicationController
  before_action :authorized, only: [:auto_login]
  def index#recherche dans la page d'accueil
    logements = []
    
    debut=params[:debut]
    
    fin=params[:fin]
    
    destination=params[:destination]
    
    nomber=params[:nombre].to_i

    if Date.parse(debut) <= Date.parse(fin)
      Logement.all.each do |logement|
        if logement.adresse.ville == params[:destination]
          EquiCourant
          
          if (logement.calendrier.startDate >= Date.parse(debut)) && (logement.calendrier.endDate <= Date.parse(fin) && logement.nombrepersonne.number>= params[:nombre].to_i)
            equipements = []
            logement.equi_famille.title.each do |equipement|
              equipements << equipement
            end
            logement.equi_logistique.title.each do |equipement|
                equipements << equipement
            end
            logement.equi_courant.title.each do |equipement|
                equipements << equipement
            end
            logements << {logement: logement,photo:logement.photos.first.photo.url, voygeurs: logement.nombrepersonne.number,ville:logement.adresse,tarif:logement.calendrier.tarif,chambres:logement.chambres.count,equipement:equipements.uniq,map:logement.map}
          elsif (logement.calendrier.startDate <= Date.parse(debut)) && (logement.calendrier.endDate >= Date.parse(fin)&& logement.nombrepersonne.number>= params[:nombre].to_i)
          equipements = []
            logement.equi_famille.title.each do |equipement|
              equipements << equipement
            end
            logement.equi_logistique.title.each do |equipement|
                equipements << equipement
            end
            logement.equi_courant.title.each do |equipement|
                equipements << equipement
            end
            logements << {logement: logement,photo:logement.photos.first.photo.url, voygeurs: logement.nombrepersonne.number,ville:logement.adresse,tarif:logement.calendrier.tarif,chambres:logement.chambres.count,equipement:equipements.uniq,map:logement.map}          end
        end
      end
      render json:{
        logements:logements,
        nombre:logements.count,
        filter:{
          debut:debut,
          fin:fin,
          destination:destination,
          nomber:nomber,
        }
      }
      
    else
         render json:{
        logements:false
      }
    end
  end
  def filter#filtre les rélta de la recherche
    logements = []
    debut = params[:filter][:debut]
    fin = params[:filter][:fin]
    filter = params[:nomber]
    type = params[:type]
    resultat = []
    resultat2 = []
    equipements = []

    Logement.all.each do |logement|
      if logement.adresse.ville == params[:filter][:destination]
        if (logement.calendrier.startDate >= Date.parse(debut)) && (logement.calendrier.endDate <= Date.parse(fin) && logement.nombrepersonne.number>= params[:filter][:nombre].to_i)
        equipements = []
            logement.equi_famille.title.each do |equipement|
              equipements << equipement
            end
            logement.equi_logistique.title.each do |equipement|
                equipements << equipement
            end
            logement.equi_courant.title.each do |equipement|
                equipements << equipement
            end
            logements << {logement: logement,photo:logement.photos.first.photo.url, voygeurs: logement.nombrepersonne.number,ville:logement.adresse,tarif:logement.calendrier.tarif,chambres:logement.chambres.count,equipement:equipements.uniq,map:logement.map}
        elsif (logement.calendrier.startDate <= Date.parse(debut)) && (logement.calendrier.endDate >= Date.parse(fin)&& logement.nombrepersonne.number>= params[:filter][:nombre].to_i)
                  equipements = []
            logement.equi_famille.title.each do |equipement|
              equipements << equipement
            end
            logement.equi_logistique.title.each do |equipement|
                equipements << equipement
            end
            logement.equi_courant.title.each do |equipement|
                equipements << equipement
            end
            logements << {logement: logement,photo:logement.photos.first.photo.url, voygeurs: logement.nombrepersonne.number,ville:logement.adresse,tarif:logement.calendrier.tarif,chambres:logement.chambres.count,equipement:equipements.uniq,map:logement.map}

        end
      end
    end
    if filter.length != 0 && type.length == 0
      filter.each do |filt|
        case filt
        when 0
          logements.each do |logement|
            if logement[:tarif] <= 100
              resultat << logement
            end
          end
        when 100
          logements.each do |logement|
            if logement[:tarif]  >= 100 && logement[:tarif]  <= 200
              resultat << logement
            end
          end
        when 200
         logements.each do |logement|
            if logement[:tarif]  >= 200 && logement[:tarif]  <= 300
              resultat << logement
            end
          end
        when 300
           logements.each do |logement|
            if logement[:tarif]  >= 300 && logement[:tarif]  <= 400
                resultat << logement
            end
          end
        when 400 
           logements.each do |logement|
            if logement[:tarif]  >= 400 
              resultat << logement
            end
          end
        end
      end
    elsif filter.length != 0 && type.length != 0
     filter.each do |filt|
        case filt
        when 0
            type.each do |typ|
            logements.each do |logement|
              if logement[:tarif] <= 100 && logement[:logement].types == typ
                resultat << logement
              end
            end
          end
        when 100
          type.each do |typ|
            logements.each do |logement|
              if logement[:tarif]  >= 100 && logement[:tarif]  <= 200 && logement[:logement].types == typ
                resultat << logement
              end
            end
          end
        when 200
          type.each do |typ|
            logements.each do |logement|
              if logement[:tarif]  >= 200 && logement[:tarif]  <= 300 && logement[:logement].types == typ
                resultat << logement
              end
            end
          end
        when 300
          type.each do |typ|
             logements.each do |logement|
              if logement[:tarif]  >= 300 && logement[:tarif]  <= 400 && logement[:logement].types == typ
                resultat << logement
              end
            end
          end
        when 400
          type.each do |typ|
            logements.each do |logement|
              if logement[:tarif]  >= 400 && logement[:logement].types == typ
                resultat << logement
              end
            end
          end
        end
      end 
    elsif filter.length == 0 && type.length != 0
      type.each do |filt|
        logements.each do |logement|
          if logement[:logement].types == filt
              resultat << logement
          end
        end
      end
    end

    if resultat.length != 0
      render json: {
        resultat:resultat
      }
    else
      render json: {
        result:"Null"
      }
    end
  end
end
