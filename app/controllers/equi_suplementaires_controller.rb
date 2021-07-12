class EquiSuplementairesController < ApplicationController
  before_action :authorized, only: [:update]

    # GET /equi_courants
    #affichages  equipements
  def index
  logement = Logement.find_by(id:params[:logement_id])
  equipement = logement.equi_suplementaire.title
     render json: {
      suplementaires:equipement
    }
  end

  #mis à jour d'equipement
  def update
    logement = Logement.find_by(id:params[:logement_id])
    if current_user.has_attribute?(:admin)
      equipement = logement.equi_suplementaire
      equipement.update(title:params[:title])
      Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - equipement suplementaire", admin_run_id: current_user.id)
    else
      equipement = logement.equi_suplementaire
      equipement.update(title:params[:title])
    end


  end
end
