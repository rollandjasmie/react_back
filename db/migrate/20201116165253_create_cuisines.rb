class CreateCuisines < ActiveRecord::Migration[6.0]
  def change
    create_table :cuisines do |t|
      t.string :title
      t.integer :quantite

      t.belongs_to :logement, index: true
      t.timestamps
    end
  end
end
