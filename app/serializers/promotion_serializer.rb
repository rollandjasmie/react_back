class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :type, :vu, :temps, :reduction, :datedebut, :datefin, :name_promotion, :datevuedebut, :datevuefin
end
