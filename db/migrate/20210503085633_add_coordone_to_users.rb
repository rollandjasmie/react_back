class AddCoordoneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :codepostal, :integer
    add_column :users, :ville, :string
    add_column :users, :departement, :string
  end
end
