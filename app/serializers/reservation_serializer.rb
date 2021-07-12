class ReservationSerializer < ActiveModel::Serializer
  attributes :id, :arrivee, :depart, :status, :commission, :duree, :montan_total, :commition_et_frais, :tarif
end
