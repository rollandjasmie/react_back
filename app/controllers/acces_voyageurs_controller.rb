class AccesVoyageursController < ApplicationController
  before_action :authorized, only: [:update]

  # GET /acces_voyageurs
  def index
      logement = Logement.find_by(id:params[:logement_id])
      equipement = logement.acces_voyageurs[0]
     
      render json: {
        acces:equipement
      }
  end

 


#mis à jour des attribut acces_voyageur qui appartient à u logement
  def update
    logement = Logement.find_by(id:params[:logement_id])
    equipement = logement.acces_voyageurs[0]
      if current_user.has_attribute?(:admin)
        if equipement.update(acces:params[:acces],aide1:params[:aide1],aide2:params[:aide2],autre:params[:autre],presentation:params[:presentation],transport:params[:transport])
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - accès aux voaygeurs", admin_run_id: current_user.id)
          render json:{
            aces:equipement
          }
        else
          render json: {error:equipement.errors, status: :unprocessable_entity}
        end
      else
        if equipement.update(acces:params[:acces],aide1:params[:aide1],aide2:params[:aide2],autre:params[:autre],presentation:params[:presentation],transport:params[:transport])
          render json:{
            aces:equipement
          }
        else
          render json: {error:equipement.errors, status: :unprocessable_entity}
        end
      end
    
  end

end
