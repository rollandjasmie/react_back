class AddAdminToAdminRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_runs, :admin, :boolean,:default => true
    add_column :admin_runs, :statu, :string
    add_column :admin_runs, :pseudo, :string
    add_column :admin_runs, :mobile, :string
    add_column :admin_runs, :adresse, :string
    add_column :admin_runs, :niveau, :string
  end
end
