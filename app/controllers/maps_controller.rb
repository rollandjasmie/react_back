class MapsController < ApplicationController
  before_action :authorized, only: [:update]

  def show
  end

  def update#mis à jour des coordonéés du map
    log = Logement.find_by(id:params[:longement_id])
    map = log.map
    if map.update(latitude:params[:latitude],longitude:params[:longitude])
      render json:{
        map:map
      }
    else
      render json:{
        error: :error
      }
    end
  end

  def delete
  end
end
