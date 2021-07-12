class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :types
      t.string :vu,:default => "Tout le monde"
      #Ex:- :default =>''
      t.integer :temps
      t.integer :reduction
      t.date :datedebut
      t.date :datefin
      t.string :name_promotion
      t.date :datevuedebut
      t.date :datevuefin
      t.belongs_to :logement,index: true

      t.timestamps
    end
  end
end
