class CreateCautions < ActiveRecord::Migration[6.0]
  def change
    create_table :cautions do |t|
      t.string :montant
      t.string :type_de_payment
      t.belongs_to :logement, index: true

      t.timestamps
    end
  end
end
