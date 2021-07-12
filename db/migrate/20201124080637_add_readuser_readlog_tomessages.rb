class AddReaduserReadlogTomessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :is_client, :boolean

    #Ex:- :default =>''
  end
end
