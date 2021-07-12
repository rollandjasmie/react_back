class Admin::RechercheController < ApplicationController
  
  #recherche un utilisateur   
  def users
      users = []
      User.all.each do |user|
        if user.name.downcase.include?(params[:name].downcase) ||  user.first_name.downcase.include?(params[:name].downcase) || user.email.downcase.include?(params[:name].downcase)
            users << user
        end
      end
    if users.present?
      render json: {users:users}
    else
       render json: {users:false}
    end  
  end

  #recherche un logement   
  def logement
     logements = []
      Logement.all.each do |logement|
        if logement.name.downcase.include?(params[:name].downcase) ||  logement.idlogement.downcase.include?(params[:name].downcase) || logement.user.name.downcase.include?(params[:name].downcase) || logement.user.first_name.downcase.include?(params[:name].downcase) || logement.user.email.downcase.include?(params[:name].downcase)
          logements << {proprietaire:logement.user,logement:logement,photo:"#{logement.photos.first.photo.url}",tarif:logement.calendrier.tarif,email:logement.user.email}  
        end
      end
    if logements.present?
      render json: {logements:logements}
    else
       render json: {logements:false}
    end  
  end

  def reservation
  end
end
