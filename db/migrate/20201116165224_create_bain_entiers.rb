class CreateBainEntiers < ActiveRecord::Migration[6.0]
  def change
    create_table :bain_entiers do |t|
      t.string :title
      t.integer :quantite
      t.belongs_to :logement, index: true
      t.timestamps
    end
  end
end
