class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
