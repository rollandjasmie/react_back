class AvatarsController < ApplicationController
  before_action :authorized, only: [:create]

  #mis à jour photo de profil      
  def create
        # Block execution if there is no current user
    if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
    end
    @users =User.find(current_user.id)
    @users.update(user_params)
        render json:{
            user: @users
        }
  end
  private

    def user_params
        params.permit(:featured_image)
    end
  
end
