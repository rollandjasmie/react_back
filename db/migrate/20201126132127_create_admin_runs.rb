class CreateAdminRuns < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_runs do |t|
      t.string :email
      t.string :password_digest
      t.string :name,:default => "RUNBNB"
      t.string :first,:default => "RUNBNB"

      t.timestamps
    end
  end
end
