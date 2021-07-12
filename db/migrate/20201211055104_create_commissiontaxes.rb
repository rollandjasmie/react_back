class CreateCommissiontaxes < ActiveRecord::Migration[6.0]
  def change
    create_table :commissiontaxes do |t|
      t.integer :commission
      t.integer :tax
      t.belongs_to :logement, index:true

      t.timestamps
    end
  end
end
