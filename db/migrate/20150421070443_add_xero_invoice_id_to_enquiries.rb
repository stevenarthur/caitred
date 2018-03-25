class AddXeroInvoiceIdToEnquiries < ActiveRecord::Migration
  def change
  	add_column :enquiries, :xero_invoice_id, :string
  end
end
