class AddReservationidToStripeCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_customers, :idreservation, :string
    remove_column :stripe_customers, :customer_id
    remove_column :stripe_customers, :payment_method_id
    add_column :stripe_customers, :customer_id, :string
    add_column :stripe_customers, :payment_method_id, :string

    


  end
end
