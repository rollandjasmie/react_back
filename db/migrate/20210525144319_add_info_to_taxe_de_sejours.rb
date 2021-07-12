class AddInfoToTaxeDeSejours < ActiveRecord::Migration[6.0]
  def change
    add_column :taxe_de_sejours, :registre, :string
    add_column :taxe_de_sejours, :tva, :string
    add_column :taxe_de_sejours, :impot, :string
    add_column :taxe_de_sejours, :categorie, :string
    add_column :taxe_de_sejours, :types, :string
  end
end
