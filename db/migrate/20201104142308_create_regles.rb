class CreateRegles < ActiveRecord::Migration[6.0]
  def change
    create_table :regles do |t|
      t.string :regle, array: true, default: []
      t.string :arrive1
      t.string :arrive2
      t.string :depart1
      t.string :depart2

      t.belongs_to :logement, index: true
      t.timestamps
    end
  end
end
