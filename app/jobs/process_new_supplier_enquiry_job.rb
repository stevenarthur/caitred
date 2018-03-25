class ProcessNewSupplierEnquiryJob < ActiveJob::Base
  queue_as :default

  def perform(request_ip, request_user_agent, supplier_enquiry_params)
    if !enquiry_spam?(request_ip, request_user_agent, supplier_enquiry_params[:more_info])
      TeamMailer.new_partnership_potential(supplier_enquiry_params).deliver_later
    end
  end

private

  def enquiry_spam?(request_ip, request_user_agent, supplier_enquiry_more_info)
    Akismet.spam?(request_ip, request_user_agent, text: supplier_enquiry_more_info)
  end

end
