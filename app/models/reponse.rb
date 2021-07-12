class Reponse < ApplicationRecord
    belongs_to :commentaire, dependent: :destroy
end
