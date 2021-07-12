class AddDescriptionToLogements < ActiveRecord::Migration[6.0]
  def change
    add_column :logements, :description, :string
    add_column :logements, :unique, :string
  end
end
