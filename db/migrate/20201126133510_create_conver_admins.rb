class CreateConverAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :conver_admins do |t|
      t.belongs_to :admin_run, index: true
      t.belongs_to :logement, index: true
      
      t.timestamps
    end
  end
end
