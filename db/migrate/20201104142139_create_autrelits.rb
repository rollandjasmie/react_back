class CreateAutrelits < ActiveRecord::Migration[6.0]
  def change
    create_table :autrelits do |t|
      t.string  :name
      t.integer :quantite
      t.boolean :checked

      t.belongs_to :autre, index: true
      t.timestamps
    end
  end
end
