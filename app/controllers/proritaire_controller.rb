class ProritaireController < ApplicationController
  before_action :authorized

  def index
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    user= current_user
    user.update(is_client:params[:is_client])
    render json: {user:user}
  end
 
end
