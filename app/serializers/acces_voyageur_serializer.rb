class AccesVoyageurSerializer < ActiveModel::Serializer
  attributes :id, :acces, :aide1, :aide2, :autre
  has_one :logements
end
