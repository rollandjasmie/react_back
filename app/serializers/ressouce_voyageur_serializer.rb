class RessouceVoyageurSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_one :logements
end
