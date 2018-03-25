class AddStripeToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :stripe_customer_token, :string
    add_column :enquiries, :stripe_payment_id, :string
    add_column :enquiries, :extras_cost, :decimal, precision: 8, scale: 2
    add_column :enquiries, :gst_paid, :decimal, precision: 8, scale: 2
  end
end
