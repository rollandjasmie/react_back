class CreateChambres < ActiveRecord::Migration[6.0]
  def change
    create_table :chambres do |t|
      t.string :title

      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
