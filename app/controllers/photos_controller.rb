require 'json'
class PhotosController < ApplicationController
  before_action :authorized, only: [:create, :update, :destroy]


  # GET /photos
  def index#affiche de toutes les photos pour un logement dans l'extrat net
  logement = Logement.find_by(id:params[:logement_id])
  photos = logement.photos.order(:id)   
  render json:{
    photo:photos
  } 

    
  end

  # GET /photos/1
  def show#affiche d'une photo pour un logement dans l'extrat net
    logement = Logement.find_by(id:params[:logement_id])
    images = logement.photos
    
    photo  = Photo.find(params[:id])
    #rang de cette image par apport à toutes les images
    rang = 0
    #nombre de toutes les images
    tout = images.count

    images.all.each do |image|     
       rang+=1
       break if (image.id ===  params[:id].to_i)
    end
     
    
    render json:{
      photo:photo,
      rang:rang,
      tout:tout
    }
    
  end

  # POST /photos
  def create#création des photos dans l'extrat net

    photos = params[:photo]
      if current_user.has_attribute?(:admin)
        photos.each do |photo|
            photo=Photo.new(photo:photo)
            photo.logement_id=params[:logement_id]
            photo.save!
        end
        logement = Logement.find(params[:logement_id])
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Ajout de(s) – photo(s)", admin_run_id: current_user.id)
      else
         photos.each do |photo|
            photo=Photo.new(photo:photo)
            photo.logement_id=params[:logement_id]
            photo.save!
        end
      end

  end

  # PATCH/PUT /photos/1
  def update#mis à jour d'une photo
    photo  = Photo.find(params[:id])
      if current_user.has_attribute?(:admin)
        logement = Logement.find(photo.logement_id)
        if params[:photo] === "null" 
          photo.update(legend:params[:legend])
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification photo –légende", admin_run_id: current_user.id)
          render json:{
            photo:photo
          }
        else
          photo.update(photo:params[:photo],legend:params[:legend])
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification photo –légende", admin_run_id: current_user.id)

          render json:{
            photo:photo
          }
        end
      else
        if params[:photo] === "null" 
                photo.update(legend:params[:legend])
          render json:{
            photo:photo
          }
        else
          photo.update(photo:params[:photo],legend:params[:legend])
          render json:{
            photo:photo
          }
        end
      end
  end

  # DELETE /photos/1
  def destroy#effacer une photo
      photo  = Photo.find(params[:id])
      if current_user.has_attribute?(:admin)
        logement = Logement.find(photo.logement_id)
          photo.destroy
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Suppression photo", admin_run_id: current_user.id)
      else
          photo.destroy
      end
  end

end
