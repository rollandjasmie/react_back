class AddVersmentToFactureVersements < ActiveRecord::Migration[6.0]
  def change
    add_column :facture_versements, :idProrio, :string
    add_column :facture_versements, :nomProprio, :string
    add_column :facture_versements, :sanstaxe, :float
    add_column :facture_versements, :statut, :string
  end
end
