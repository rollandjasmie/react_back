class CautionsController < ApplicationController
    before_action :authorized, only: [:update]

  # GET /cautions
  def index
    logement = Logement.find(params[:logement_id])
    montant = logement.caution.montant
    type_de_payment = logement.caution.type_de_payment
    id = logement.caution.id

    render json:{
      montant:montant,
      type_de_payment:type_de_payment,
      id:id
    }

  end


  def update
    logement = Logement.find(params[:logement_id])
    caution = logement.caution
    if caution.update(montant:params[:montant],type_de_payment:params[:type_de_payment])
      render json: {
          caution:caution
      }
    end
  end
end
