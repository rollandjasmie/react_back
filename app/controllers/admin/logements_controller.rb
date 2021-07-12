class Admin::LogementsController < ApplicationController
  before_action :authorized, only: [:delete]

  #tous les legements
  def index
    logements = Logement.all
    #liste tous les legements avec le propriétaires,photo
    log = []
    logements.each do |logement|
      
      if Rails.env == "production"
        log << {proprietaire:logement.user,logement:logement,photo:"#{logement.photos.first.photo.url}",tarif: logement.calendrier ? logement.calendrier.tarif : 0}
      else
        log << {proprietaire:logement.user,logement:logement,photo:"#{logement.photos.first.photo.url}",tarif: logement.calendrier ? logement.calendrier.tarif : 0}
      end
      
    end
    render json: {logements:log}
  end

  #affichage d'un logement
  def show
    logement = Logement.find(params[:logement_id])
    render json: {logement:logement,photo:"#{logement.photos.first.photo.url}"}
  end
#effacer un logement
  def delete
    logement = Logement.find(params[:logement_id])
    if logement.destroy
      render json:{status: :"Ok"}
    end
  end
end
