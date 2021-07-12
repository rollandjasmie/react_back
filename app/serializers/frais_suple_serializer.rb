class FraisSupleSerializer < ActiveModel::Serializer
  attributes :id, :type, :montant, :facturation, :references
end
