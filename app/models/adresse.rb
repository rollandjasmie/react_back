class Adresse < ApplicationRecord
    belongs_to:logement
    validates :code,  presence: { message: "can't be blank" },numericality:{minimum: 0}
    validates :ville,  presence: { message: "can't be blank" }
    validates :adresse,  presence: { message: "can't be blank" }

end
