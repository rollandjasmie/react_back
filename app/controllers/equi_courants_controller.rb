class EquiCourantsController < ApplicationController
  before_action :authorized, only: [:update]

  # GET /equi_courants
  #affichages 3 equipements
  def index
  logement = Logement.find_by(id:params[:logement_id])
  equipement = logement.equi_courant.title
  tables = []
    o = 0
    for i in 0...3
      o+=1
      tables << equipement[(equipement.count - o)]
    end

     render json: {
      courant:equipement,
      tables:tables
    }
  end

  def update#mis à jour d'equipement
    if current_user.has_attribute?(:admin)
        logement = Logement.find_by(id:params[:logement_id])
        equipement = logement.equi_courant
        equipement.update(title:params[:title])
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - equipement courant", admin_run_id: current_user.id)
    else
      logement = Logement.find_by(id:params[:logement_id])
      equipement = logement.equi_courant
      equipement.update(title:params[:title])
    end
  end
    
end
