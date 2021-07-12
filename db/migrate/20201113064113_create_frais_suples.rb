class CreateFraisSuples < ActiveRecord::Migration[6.0]
  def change
    create_table :frais_suples do |t|
      t.string :types
      t.string :montant
      t.string :facturation
      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
