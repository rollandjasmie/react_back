class CreateReponses < ActiveRecord::Migration[6.0]
  def change
    create_table :reponses do |t|
      t.string :content
      t.integer :is_client
      t.string :name
      t.belongs_to :commentaire, index:true
      
      t.timestamps
    end
  end
end
