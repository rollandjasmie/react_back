class Commentaire < ApplicationRecord
    belongs_to :user
    belongs_to :logement
    has_many :reponses, dependent: :destroy
end
