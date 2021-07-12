class AddFileToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :files, :json
  end
end
