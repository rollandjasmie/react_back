class CreateTaxeDeSejours < ActiveRecord::Migration[6.0]
  def change
    create_table :taxe_de_sejours do |t|
      t.float :taxe,:default => 25
      t.belongs_to :logement, index:true

      t.timestamps
    end
  end
end
