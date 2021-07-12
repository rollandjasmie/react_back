class TaxesController < ApplicationController
  before_action :authorized, only: [:update]

  def index#affichage
    logement = Logement.find(params[:logement_id])
    taxe = logement.taxe_de_sejour
    render json: {taxe:taxe}
  end

  def update
    logement = Logement.find(params[:logement_id])
    taxe = logement.taxe_de_sejour
    if current_user.has_attribute?(:admin)
      taxe.update(taxe_params)
      render json:{status:200}
      Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - Logement - taxe", admin_run_id: current_user.id)
    else
      taxe.update(taxe_params)
      render json:{status:200}
    end
  end
  private
  def taxe_params
    params.permit(:taxe,:registre,:tva,:impot,:categorie,:types,:logement_id,:tax)
  end
  
end
