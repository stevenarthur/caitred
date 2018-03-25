class CustomerSmsReminderWorker
  include Sidekiq::Worker

  REMINDER_TIME = 120.minutes # minutes before delivery

  def perform(enquiry_id)

  	@enquiry = Enquiry.find(enquiry_id)
    t = Telstra::SMS.new(ENV['TELSTRA_CONSUMER_KEY'], ENV['TELSTRA_CONSUMER_SECRET'])
    response = t.send_sms(
      to: @enquiry.customer.telephone, 
      body: "Hi #{@enquiry.customer.first_name}. Your Caitre'd foodie goodness will arrive at #{@enquiry.delivery_time}. Enjoy and we look forward to the feedback! Thanks, Caitre'd.")
  end

end
