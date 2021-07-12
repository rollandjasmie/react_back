class CreateNombrepersonnes < ActiveRecord::Migration[6.0]
  def change
    create_table :nombrepersonnes do |t|
      t.integer :number,:default => 0
      t.belongs_to:logement,index:true

      t.timestamps
    end
  end
end
