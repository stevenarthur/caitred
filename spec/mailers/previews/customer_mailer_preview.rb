class CustomerMailerPreview < ActionMailer::Preview

  def new_registration
    customer = Customer.last
    CustomerMailer.new_registration(customer)
  end

  def reset_password
    customer = Customer.last
    customer.password_reset_token = SecureRandom.urlsafe_base64(30)
    CustomerMailer.reset_password(customer)
  end

  def new_order_confirmation
    enquiry = Enquiry.find(1032)
    CustomerMailer.new_order_confirmation(enquiry)
  end

  def enquiry_invoice
    enquiry = Enquiry.find(1032)
    CustomerMailer.enquiry_invoice(enquiry)
  end

  def customer_feedback
    enquiry = Enquiry.find(1032)
    CustomerMailer.customer_feedback(enquiry)
  end

end
