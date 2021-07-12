class ReponsesController < ApplicationController
  before_action :authorized

	def create
		#création d'une réponse d'un commentaire =====#
		# Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
		#====================== propriétaires ==========================#
		@comment = Commentaire.find(params[:id])
		@answer = Reponse.create(content: params[:content], user_id: current_user.id, comment_id: @comment.id)
	end

end
