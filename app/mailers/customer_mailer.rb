class CustomerMailer < ApplicationMailer

  # Previously Mailers::CustomerRegistrationMail ('Customer Registration' Template in Mandrill)
  def new_registration(customer)
    @customer = customer
    file = File.open(Rails.root.join("app/assets/images/mailers/CateringGuideCD.pdf")){ |f| f.read }
    attachments["caitred_catering_guide.pdf"] = file
    mail(to: @customer.email, 
         subject: "#{@customer.first_name}, welcome to Caitre'd - our gift to you")
  end

  # Previously Mailers::CustomerPasswordResetMail ('Customer Password Reset' Template in Mandrill)
  def reset_password(customer)
    @customer = customer
    mail(to: @customer.email,
         subject: "Password Reset for your Caitre'd account")
  end

  # Previously Mailers::CustomerConfirmationMail ('Customer Order Confirmation' Template in Mandrill)
  def new_order_confirmation(enquiry)
    @enquiry = enquiry
    @customer = @enquiry.customer
    mail(to: @customer.email,
         subject: "Your booking request ##{@enquiry.id} for #{@enquiry.event_date.try(:strftime, "%e %B %Y")} has been received")
  end

  # Previously Mailers::CustomerInvoiceMail ('Customer Invoice' Template in Mandrill)
  # This happens once the order has been confirmed.
  def enquiry_invoice(enquiry)
    @enquiry = enquiry
    @customer = @enquiry.customer
    file = open(Storage.download("caitre_d_order_#{@enquiry.id}.pdf")){ |f| f.read }
    attachments["caitre_d_order_#{@enquiry.id}.pdf"] = file
    mail(to: @customer.email,
         subject: "Your booking request ##{@enquiry.id} for #{@enquiry.event_date.try(:strftime, "%e %B %Y")} has been accepted")
  end

  # Previously Mailers::CustomerFeedbackMail ('Customer Feedback' Template in Mandrill)
  def customer_feedback(enquiry)
    @enquiry = enquiry
    @customer = @enquiry.customer
    mail(to: @customer.email,
         subject: "#{@customer.first_name}, how was your Caitre’d experience for booking ##{@enquiry.id} on #{@enquiry.event_date.try(:strftime, "%e %B %Y")}")
  end

end
