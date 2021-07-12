class Salon < ApplicationRecord
    has_many :canapes, dependent: :destroy
end
