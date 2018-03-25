class GenerateInvoiceWorker
  include Sidekiq::Worker

  def perform(enquiry_id)
  	@enquiry = Enquiry.find(enquiry_id)
    invoice = Xero::CustomerInvoiceCreator.from_enquiry(@enquiry)
    invoice.save
    @enquiry.update_attributes(xero_invoice_id: invoice.invoice_id)
    doc = invoice.pdf
    Storage.upload doc, "invoices/caitre_d_order_#{@enquiry.id}.pdf"

    ## This should only send the first time the order has been confirmed
    unless @enquiry.status_audits.pluck(:new_status).include?("Confirmed")
      CustomerMailer.enquiry_invoice(@enquiry).deliver_later
    end
  end

end
