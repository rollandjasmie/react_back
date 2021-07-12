class CreateEquiSecurites < ActiveRecord::Migration[6.0]
  def change
    create_table :equi_securites do |t|
      t.string :title, array: true, default: []
      t.string :Extincteur
      t.string :incendie
      t.string :gaz
      t.string :medicale
      t.string :Police

      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
