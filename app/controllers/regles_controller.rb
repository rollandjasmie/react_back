class ReglesController < ApplicationController
  before_action :authorized, only: [:upadte]

  def index#affichage des reglements interieurs
      log = Logement.find_by(id:params[:longement_id])
      regles= log.regle
      render json:{
        regles:regles
      }

  end

  def upadte
    logement = Logement.find_by(id:params[:longement_id])
      if current_user.has_attribute?(:admin)
        #réglement interieur
        regles= logement.regle
        regles.update(params_regele)

        #condition d'annulation
        condition= logement.condition
        condition.update(conditions:params[:conditions])
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - règles et Conditions d’annulation", admin_run_id: current_user.id)
      else
        regles= logement.regle
        regles.update(params_regele)
        condition= logement.condition
        condition.update(conditions:params[:conditions])
      end
  end
  private
  def params_regele
    params.require(:regle).permit(:arrive1,:arrive2,:depart1,:depart2)
  end
  
end
