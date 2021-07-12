class AddCogestionToLogements < ActiveRecord::Migration[6.0]
  def change
    add_column :logements, :cogestion, :integer,array:true,default:[]
  end
end
