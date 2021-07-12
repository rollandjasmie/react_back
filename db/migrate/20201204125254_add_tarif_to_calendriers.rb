class AddTarifToCalendriers < ActiveRecord::Migration[6.0]
  def change
    add_column :calendriers, :tarif, :integer
  end
end
