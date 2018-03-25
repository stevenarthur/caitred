class AddXeroSupplierInvoiceIdToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :supplier_xero_invoice_id, :string
  end
end
