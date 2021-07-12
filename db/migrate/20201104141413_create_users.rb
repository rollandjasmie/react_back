class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :first_name
      t.string :adresse
      t.string :mobile
      t.string :date_of_birth
      t.string :sexe
      t.string :urgence
      
      t.timestamps
    end
  end
end
