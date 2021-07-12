class AddIdadminToAdminRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_runs, :idadmin, :string
  end
end
