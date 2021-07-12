class RessouceVoyageursController < ApplicationController
    before_action :authorized, only: [:update]

  # GET /ressouce_voyageurs
    def index
      logement = Logement.find(params[:logement_id])
      ressources = logement.ressouce_voyageurs[0]
      render json:{
        ressources:ressources
      }
    end

    def update# /ressouce_voyageurs
      logement = Logement.find(params[:logement_id])
      ressources = logement.ressouce_voyageurs[0]
      if current_user.has_attribute?(:admin)
        ressources.update(title:params[:ressources])
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - réssources voyageurs", admin_run_id: current_user.id)
      else
       ressources.update(title:params[:ressources])
      end
     
    end
end
