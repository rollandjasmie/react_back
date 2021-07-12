class Reservation < ApplicationRecord
    belongs_to :logement
    belongs_to :user
end
