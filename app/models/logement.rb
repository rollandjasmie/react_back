class Logement < ApplicationRecord


    validates :name, presence: { message: "can't be blank" }, on: :create
    validates :categorie,  presence: { message: "can't be blank" }, on: :create
    validates :types,  presence: { message: "can't be blank" }, on: :create

    belongs_to :user
    has_one :adresse, dependent: :destroy
    has_one :map, dependent: :destroy
    has_one :condition, dependent: :destroy
    has_one :calendrier, dependent: :destroy
    has_many :equipements, dependent: :destroy
    has_one :regle, dependent: :destroy
    has_many :chambres, dependent: :destroy
    has_many :salons, dependent: :destroy
    has_many :autres, dependent: :destroy
    has_many :photos, dependent: :destroy
    has_one :equi_courant, dependent: :destroy
    has_one :equi_famille, dependent: :destroy
    has_one :equi_logistique, dependent: :destroy
    has_many :equi_securites, dependent: :destroy
    has_one :equi_suplementaire, dependent: :destroy
    has_many :acces_voyageurs, dependent: :destroy
    has_many :ressouce_voyageurs, dependent: :destroy
    has_one :parms_reservation, dependent: :destroy
    has_one  :caution, dependent: :destroy
    has_many :frais_suples, dependent: :destroy
    has_many :bain_entiers, dependent: :destroy
    has_many :bain_demis, dependent: :destroy
    has_many :cuisines, dependent: :destroy
    has_many :kitchenettes, dependent: :destroy
    has_many :espace_repas, dependent: :destroy
    has_many :promotions, dependent: :destroy
    has_one  :nombrepersonne, dependent: :destroy
    has_many :reservations, dependent: :destroy
    has_one :commissiontax, dependent: :destroy
    has_many :commentaires, dependent: :destroy
    has_many :facture_versements, dependent: :destroy
    has_one :taxe_de_sejour, dependent: :destroy
    

    
    has_many :conversations
    has_many :users, through: :conversations

    has_one :conver_admin
    has_one :admin_run, through: :conver_admin

end
