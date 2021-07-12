class DestinationController < ApplicationController
  
  #tous les logements classé par ville
  def index
    logements = Logement.all
    destination = []
    logements.each do|logement|
      if logement.adresse.ville == params[:destinations] && logement.status == true
          if logement.promotions.present? && logement.promotions.last.datevuedebut <= Date.today && Date.today <= logement.promotions.last.datevuefin
            destination << {logement: logement,photo:"#{logement.photos.first.photo.url}", calendrier: logement.calendrier,ville:logement.adresse.ville,promotion:logement.promotions.last}   
          else
            destination << {logement: logement,photo:"#{logement.photos.first.photo.url}", calendrier: logement.calendrier,ville:logement.adresse.ville}
          end
      end
    end
    render json: {destination:destination}
  end
  #tous les logement qui ont des promotions
  def tout_offre
     logements = []
       Logement.all.each do |logement| 
        if logement.status == true
          if logement.promotions.present? && logement.promotions.last.datevuedebut <= Date.today && Date.today <= logement.promotions.last.datevuefin
            logements << {logement: logement,photo:"#{logement.photos.first.photo.url}", calendrier: logement.calendrier,ville:logement.adresse.ville,promotion:logement.promotions.last} 
          end
          # logements << {logement: logement,photo:logement.photos.first.photo.url, calendrier: logement.calendrier,ville:logement.adresse.ville}
        end
        
      end
      render json: {logement: logements}
    
  end
  
end
