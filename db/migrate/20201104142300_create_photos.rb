class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.json :photo
      t.string :legend
      
      t.belongs_to :logement, index: true      
      t.timestamps
    end
  end
end
