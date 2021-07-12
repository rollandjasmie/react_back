class CreateMessageAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :message_admins do |t|
      t.string :content
      t.boolean :read, :default => false
      t.integer :is_admin
      t.json :files
      t.belongs_to :conver_admin, index: true
      
      t.timestamps
    end
  end
end
