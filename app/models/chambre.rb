class Chambre < ApplicationRecord
    has_many :lits, dependent: :destroy
end
