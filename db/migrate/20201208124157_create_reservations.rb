class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.string :idreservation
      t.date :arrivee
      t.date :depart
      t.string :status
      t.integer :commission
      t.integer :duree
      t.integer :montan_total
      t.integer :commition_et_frais
      t.integer :tarif
      t.integer :nombre_personne
      t.string  :numero_credit
      t.belongs_to :user,index:true
      t.belongs_to :logement,index:true



      t.timestamps
    end
  end
end
