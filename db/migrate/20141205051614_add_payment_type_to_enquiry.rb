class AddPaymentTypeToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :payment_method, :string, default: PaymentMethod::CREDIT_CARD.to_s
  end
end
