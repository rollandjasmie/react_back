class AddStatuToLogements < ActiveRecord::Migration[6.0]
  def change
    add_column :logements, :status, :boolean,:default => true
  end
end
