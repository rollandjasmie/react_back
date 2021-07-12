class CreateFactureVersements < ActiveRecord::Migration[6.0]
  def change
    create_table :facture_versements do |t|
      t.string :numreservation
      t.string :voyageur
      t.float :montantnet
      t.date :datedevirment
      t.string :sejour
      t.float :tariftotal
      t.float :commission
      t.float :taxe
      t.belongs_to :logement, index:true
      t.belongs_to :user, index:true

      t.timestamps
    end
  end
end
