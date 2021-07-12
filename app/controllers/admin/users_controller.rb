class Admin::UsersController < ApplicationController
 before_action :authorized, only: [:delete]
 
  #liste de tous les utilisateurs
  def index
    user= User.all
    render json: {users:user}
  end
  #affichage d'un utilisateur

  def show
      show= User.find(params[:user_id])
        
        atta = show.featured_image.attached?
        if atta 
            avatar = rails_blob_path(show.featured_image)
            user_id = {user:show,avatar:"#{avatar}",photo:atta}
              render json:{
                  user:user_id
              }
        else 
            user_id = {user:show,photo:atta}

            render json:{
                user:user_id
            }
        end
  end

  #effacer un utilisateur
  def delete
    user = User.find(params[:user_id])
    if user.destroy
      render json: :"effacer"
    end
    
    
  end
end
