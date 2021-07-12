class EquipementsController < ApplicationController
  before_action :authorized, only: [:create]

  def index
    logement = Logement.find(params[:logement_id])
    equipement = Equipement.find_by(logement_id:params[:logement_id])
    render json: {
      courant:equipement
    }
  end

  def create#créatio des espace bain,cuisine,Kitchenette
    @chambre = Chambre.create(title:"Chambre",logement_id: @logement.id)
        @bain_entier = BainEntier.create(title:"Salle de bain entière : Toilette, lavabo, douce et baignoire
        ",quantite: params[:quantite],logement_id: @logement.id)
        @bain_demi = BainDemi.create(title:"Demi-salle de bain : Toilette et lavabo
        ",quantite: params[:quantite],logement_id: @logement.id)
        @cuisine = Cuisine.create(title:"Cuisine entière
        ",quantite: params[:quantite],logement_id: @logement.id)
        @kitchenette = Kitchenette.create(title:"Kitchenette : un espace compact pour préparer à manger
        ",quantite: params[:quantite],logement_id: @logement.id)
        adresse= params[:localisation]
        adresse= JSON.parse(adresse)
        @adresse = Adresse.new(pays:adresse["pays"],ville:adresse["ville"],adresse:adresse["adresse"],code:adresse["code"])
        @adresse.logement_id = @logement.id
        @adresse.save
  end

  def update
  end

  def delete
  end
end
