class ConditionsController < ApplicationController
  before_action :authorized, only: [:upadte]

  def index#afficher le condition d'annulation
      log = Logement.find_by(id:params[:longement_id])
      condition= log.condition
      render json:{
        condition:condition
      }

  end

  def upadte#mis a à jour  (condition d'annulation)
    log = Logement.find_by(id:params[:longement_id])
    condition= log.condition
    condition.update(conditions:params[:conditions])
      
  end
end
