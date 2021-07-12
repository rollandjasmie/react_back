class CreateCoordoneBancaires < ActiveRecord::Migration[6.0]
  def change
    create_table :coordone_bancaires do |t|
      t.string :numero
      t.integer :mois
      t.integer :year
      t.integer :CVC
      t.integer :code
      t.string :titulaire
      t.belongs_to :user, index: true


      t.timestamps
    end
  end
end
