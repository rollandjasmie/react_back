class CreateCalendriers < ActiveRecord::Migration[6.0]
  def change
    create_table :calendriers do |t|
      t.date :startDate
      t.date :endDate
      t.integer :delaimin
      t.integer :nuitmin
      t.string :ouvrir, :default => "yes"
        
      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
