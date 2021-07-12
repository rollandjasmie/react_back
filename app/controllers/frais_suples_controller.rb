class FraisSuplesController < ApplicationController
  before_action :authorized, only: [:create, :delete]

  # GET /frais_suples
  #affichage des frais supplementaires
  def index
    logement = Logement.find(params[:logement_id])
    
    if logement.frais_suples.present?  
        frais_suples = logement.frais_suples
       render json:{
         frais_suples:frais_suples
       }
    else
      render json:{
         ok: :"no"
       }
    end
  end

  def create
    frais_suple = FraisSuple.new(types:params[:types], montant:params[:montant], facturation:params[:facturation], logement_id:params[:logement_id])
    logement = Logement.find(params[:logement_id])
      if current_user.has_attribute?(:admin)
        if frais_suple.save
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Création - frais supplémentaires", admin_run_id: current_user.id)
          render json:{
            frais_suple:frais_suple
          }
        else
          render json:{
            frais_suple:frais_suple.errors,
            status: :unprocessable_entity
          }
        end
      else
        if frais_suple.save
          render json:{
            frais_suple:frais_suple
          }
        else
          render json:{
            frais_suple:frais_suple.errors,
            status: :unprocessable_entity
          }
        end
      end
  end

  def delete
    frais_suple = FraisSuple.find(params[:id])
    logement = Logement.find(frais_suple.logement_id)
    if current_user.has_attribute?(:admin)
      frais_suple.delete
      Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Suppression - frais supplémentaires", admin_run_id: current_user.id)
    else
      frais_suple.delete
    end

  end

end
