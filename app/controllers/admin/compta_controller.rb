class Admin::ComptaController < ApplicationController
  before_action :authorized, only: [:index]

  #liste de tous les versements
  def index
    comptas = FactureVersement.all
    render json:{
      comptas:comptas
    }
  end

  #filtrage des versements 
  def filtre

    data = params[:filtre]
    comptas = []

    #filtrage des versements 
    FactureVersement.all.each do |filtre|
      case data
    #tous    
      when "all"
          comptas << filtre
    #términé      
      when "OK"
        if filtre.datedevirment < Date.today
          comptas << filtre
        end
    #Aujourd'hui      
        
      when "0"
        if filtre.datedevirment == Date.today
          comptas << filtre
        end
    # entre aujourd'hui et demain      
        
      when "1"
        if filtre.datedevirment >= Date.today && filtre.datedevirment <= Date.today+1
          comptas << filtre
        end
    # entre aujourd'hui et dans 3 jours      

      when "3"
        if filtre.datedevirment >= Date.today && filtre.datedevirment <= Date.today+3
          comptas << filtre
        end
    # entre aujourd'hui et dans 7 jours      

      when "7"
        if filtre.datedevirment >= Date.today && filtre.datedevirment <= Date.today+7
          comptas << filtre
        end
    # entre aujourd'hui et dans 14 jours      

      when "14"
        if filtre.datedevirment >= Date.today && filtre.datedevirment <= Date.today+14
          comptas << filtre
        end
    # entre aujourd'hui et dans 30 jours      

      when "30"
        if filtre.datedevirment >= Date.today && filtre.datedevirment <= Date.today+30
          comptas << filtre
        end
      end
    end
    #si le filtra existe
    if comptas.present?
      render json:{
        comptas:comptas
      }
    else
      render json:{
        comptas:nil
      } 
    end
    
  end

  # recherche d'un versement
  def recherche
    data = params[:recherche]
    comptas=[]

    FactureVersement.all.each do |compta|
      if compta.numreservation.downcase.include?(data.downcase) || compta.idProrio.downcase.include?(data.downcase) || compta.nomProprio.downcase.include?(data.downcase) 
        comptas << compta
      end
    end
    if comptas.present?
      render json:{
        comptas:comptas
      }
    else
      render json:{
        comptas:nil
      } 
    end
    
  end
  
  
end
