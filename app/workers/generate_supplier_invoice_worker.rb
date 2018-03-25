class GenerateSupplierInvoiceWorker
  include Sidekiq::Worker

  def perform(enquiry_id)
  	@enquiry = Enquiry.find(enquiry_id)
    invoice = Xero::SupplierInvoiceCreator.from_enquiry(@enquiry)
    invoice.save
    @enquiry.update_attributes(supplier_xero_invoice_id: invoice.invoice_id)
  end

end
