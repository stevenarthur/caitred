module Admin
  class InvoiceController < AdminController
    before_action :require_admin_authentication

    def create
      enquiry = Enquiry.find params[:enquiry_id]
      fail unless Xero::CustomerInvoiceCreator.from_enquiry(enquiry).save
    end
  end
end
