class ProcessOrderJob < ActiveJob::Base
  queue_as :default

  def perform(enquiry_id)
    @enquiry = Enquiry.find(enquiry_id)
    send_emails
  end

private
  def send_emails
    send_customer_email
    notice_team_new_order
  end

  def send_customer_email
    CustomerMailer.new_order_confirmation(@enquiry).deliver_later
  end

  def notice_team_new_order
    TeamMailer.new_order_notice(@enquiry).deliver_later
  end

end
