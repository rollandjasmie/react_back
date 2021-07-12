class HistoriqueController < ApplicationController
  before_action :authorized

  #affichage des historique 
  def index
    historys = Historique.all
    if historys.present?
      render json:{
        history:historys
      }
    else
      render json:{
        history:nil
      }
    end
  end

  #recherche un historique
  def recherche
    data = params[:data]
    historys = []

    Historique.all.each do |histori|
      if  histori.pseudoadmin.downcase.include?(data) ||  histori.prorietaire.downcase.include?(data) ||  histori.action.downcase.include?(data)
        historys << histori
      end
    end
    
    if historys.present?
      render json:{
        history:historys
      }
    else
      render json:{
        history:nil
      }
    end
    
  end
end
