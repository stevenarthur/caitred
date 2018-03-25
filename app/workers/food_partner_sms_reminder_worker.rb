class FoodPartnerSmsReminderWorker
  include Sidekiq::Worker

  def perform(enquiry_id)

  	@enquiry = Enquiry.find(enquiry_id)
    message = "Hi #{@enquiry.food_partner.contact_first_name}. The order ##{@enquiry.id} is expected at #{@enquiry.delivery_time} in #{@enquiry.address.suburb} at #{@enquiry.address.company}. Thanks, Caitre'd."

    t = Telstra::SMS.new(ENV['TELSTRA_CONSUMER_KEY'], ENV['TELSTRA_CONSUMER_SECRET'])
    response = t.send_sms(
      to: @enquiry.food_partner.phone_number, 
      body: message)
  end


end
