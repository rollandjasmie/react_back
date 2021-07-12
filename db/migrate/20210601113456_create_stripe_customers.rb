class CreateStripeCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_customers do |t|
      t.integer :customer_id
      t.integer :payment_method_id
      t.string :user_email

      t.timestamps
    end
  end
end
