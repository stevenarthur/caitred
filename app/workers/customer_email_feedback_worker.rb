class CustomerEmailFeedbackWorker
  include Sidekiq::Worker

  def perform(enquiry_id)
  	@enquiry = Enquiry.find(enquiry_id)
    CustomerMailer.customer_feedback(@enquiry).deliver_later
  end

end
