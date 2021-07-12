class CreateMaps < ActiveRecord::Migration[6.0]
  def change
    create_table :maps do |t|
      t.float :latitude
      t.float :longitude
      t.float :zoom

      t.belongs_to :logement, index: true
      t.timestamps
    end
  end
end
