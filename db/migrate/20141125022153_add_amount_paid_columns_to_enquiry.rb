class AddAmountPaidColumnsToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :total_amount_paid, :decimal, precision: 8, scale: 2
    add_column :enquiries, :payment_fee_paid, :decimal, precision: 8, scale: 2
  end
end
