class BainEntiersController < ApplicationController
    before_action :authorized, only: [:index]

    #recuperations des piece pour la chambre
    def index
        # Block execution if there is no current user
        if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
        end

        user = User.find(current_user.id)
        logement = Logement.find_by(id:params[:logement_id])
        bain_demi = BainDemi.find_by(logement_id: params[:logement_id])
        bain_entier = BainEntier.find_by(logement_id: params[:logement_id])
        cuisine = Cuisine.find_by(logement_id: params[:logement_id])
        kit= Kitchenette.find_by(logement_id: params[:logement_id])

      
        render json:{
            bain_demi:bain_demi, bain_entier:bain_entier, cuisine:cuisine, kit:kit
        }
    end
end
