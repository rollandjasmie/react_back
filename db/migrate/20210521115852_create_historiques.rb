class CreateHistoriques < ActiveRecord::Migration[6.0]
  def change
    create_table :historiques do |t|
      t.string :pseudoadmin
      t.string :prorietaire
      t.string :action
      t.belongs_to :admin_run, index: true

      t.timestamps
    end
  end
end
