class CreateCommentaires < ActiveRecord::Migration[6.0]
  def change
    create_table :commentaires do |t|
      t.string :content
      t.integer :note
      t.string :name
      t.belongs_to :logement, index:true
      t.belongs_to :user, index:true

      t.timestamps
    end
  end
end
