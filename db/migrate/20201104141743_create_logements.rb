class CreateLogements < ActiveRecord::Migration[6.0]
  def change
    create_table :logements do |t|
      t.string :name
      t.string :categorie
      t.string :types
      
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
