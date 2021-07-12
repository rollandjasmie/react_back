class CogestionController < ApplicationController
    before_action :authorized, only: [:delete]
  
  #liste des co-hotes pour un logement
  def index
    logement = Logement.find(params[:logement_id])
     #== admin = propriétaire du logement et les co-hotes ===========
     #atta = photo de profil de la propriétaie
     atta = logement.user.featured_image.attached?
      admin=nil
    if atta 
      
      avatar = rails_blob_path(logement.user.featured_image)
      admin = {admin:logement.user,photos:"/#{avatar}"}
      
    else 
      admin = {admin:logement.user,photos:nil}
    end
    #=============================
    users = logement.cogestion
    cohote = []
    if users
      users.each do |user|
        #atta = photo de profil du co-hote
        atta = User.find(user).featured_image.attached?
        if atta 
          avatar = rails_blob_path(logement.user.featured_image)
          cohote << {cohote:User.find(user),photos:"#{avatar}"}
        else 
          cohote <<  {cohote:User.find(user),photos:nil}
        end
      end
    end
    
    if cohote.present?
      render json: { admin: admin,cohote:cohote}
    else
      render json: { admin: admin,cohote:nil}
    end
    
  end
#effacer un co_hote
  def delete
    id = params[:id]
    logement = Logement.find(params[:logement_id])
    cogestion = logement.cogestion
    cogestion.delete(id.to_i)
    logement.update(cogestion:cogestion)
     if current_user.has_attribute?(:admin)
      Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Suppression - co-gestionnaire", admin_run_id: current_user.id)
    end
    render json: { delete: :ok}
  end
end
