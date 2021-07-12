class EquiSecuritesController < ApplicationController
  before_action :authorized, only: [:update]

  # GET /equi_courants
  #affichages  equipements
  def index
  logement = Logement.find_by(id:params[:logement_id])
  equipement = logement.equi_securites[0].title
  equipements = logement.equi_securites[0]

     render json: {
      securites:equipement,
      fichier:equipements
    }
  end

  
  #mis à jour d'equipement
  def update
    logement = Logement.find_by(id:params[:logement_id])
    if current_user.has_attribute?(:admin)
      equipement = logement.equi_securites[0]
      equipement.update(title:params[:title],Extincteur:params[:Extincteur],incendie:params[:incendie],gaz:params[:gaz],medicale:params[:medicale],Police:params[:Police])

      Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - equipement sécurité", admin_run_id: current_user.id)
    else
      equipement = logement.equi_securites[0]
      equipement.update(title:params[:title],Extincteur:params[:Extincteur],incendie:params[:incendie],gaz:params[:gaz],medicale:params[:medicale],Police:params[:Police])
    end

  end
end
