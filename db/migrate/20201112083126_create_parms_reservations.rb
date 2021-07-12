class CreateParmsReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :parms_reservations do |t|
      t.string :title, array: true, default: []
      t.string :autre
      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
