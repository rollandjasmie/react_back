class Autre < ApplicationRecord
    has_many :autrelits, dependent: :destroy
end
