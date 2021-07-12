class CautionSerializer < ActiveModel::Serializer
  attributes :id, :montant, :type_de_payment, :references
end
