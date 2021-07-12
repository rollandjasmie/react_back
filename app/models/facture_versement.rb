class FactureVersement < ApplicationRecord
    belongs_to :user
    belongs_to :logement

end
