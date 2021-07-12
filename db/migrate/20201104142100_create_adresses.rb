class CreateAdresses < ActiveRecord::Migration[6.0]
  def change
    create_table :adresses do |t|
      t.string :pays
      t.string :ville
      t.string :adresse
      t.string :code


      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
