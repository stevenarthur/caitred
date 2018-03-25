class FoodPartnerMailerPreview < ActionMailer::Preview
  def new_order_notice
    enquiry = Enquiry.find(3047)
    FoodPartnerMailer.new_order_notice(enquiry, "Here is some additional content")
  end
  def reminder_notice
    enquiry = Enquiry.find(3047)
    FoodPartnerMailer.reminder_notice(enquiry)
  end
end
