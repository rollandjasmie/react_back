class AddIdlogementsToLogements < ActiveRecord::Migration[6.0]
  def change
    add_column :logements, :idlogement, :string
  end
end
