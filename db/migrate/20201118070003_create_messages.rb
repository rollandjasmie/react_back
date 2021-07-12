class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.boolean :read, :default => false
      t.belongs_to :conversation, index: true
      

      t.timestamps
    end
  end
end
