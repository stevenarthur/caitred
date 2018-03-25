class FoodPartnerMailer < ApplicationMailer

  # Notifies the food partner an order has been received and
  # allows the food parter to accept or decline the order
  # Previously Mailers::PartnerNewOrderMail ('Vendor Confirmation' Template in Mandrill)
  def new_order_notice(enquiry, modified_content)
    @enquiry = enquiry
    @food_partner = @enquiry.food_partner
    @modified_content = modified_content
    mail(to: @food_partner.email_recipients,
         subject: "Caitre'd Job for #{@enquiry.event_date.strftime("%e %B %Y")} (Order ##{@enquiry.id})")
  end

  def reminder_notice(enquiry)
    @enquiry = enquiry
    @food_partner = @enquiry.food_partner
    mail(to: @food_partner.email_recipients,
         subject: "Caitre'd Check-in for #{@enquiry.event_date.strftime("%e %B %Y")} (Order ##{@enquiry.id})")
  end

end
