class AddIdUserToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :iduser, :string
  end
end
