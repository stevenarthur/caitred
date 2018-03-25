class TeamMailer < ApplicationMailer
 default to: "atyourservice@caitre-d.com",
             from: "noreply@caitre-d.com"

  # Previously Mailers::TeamNewOrderMail ('Team new order' Template in Mandrill)
  def new_order_notice(enquiry)
    @enquiry = enquiry
    @customer = @enquiry.customer
    mail(subject: "[team] New Order #{@enquiry.id}")
  end

  # Previously Mailers::TeamNewQuoteMail ('Team new quote' Template in Mandrill)
  def new_quote_notice(quote)
    @quote = quote
    mail(subject: "[team] New Enquiry Received")
  end

  # Previously Mailers::TeamNewQuoteMail ('Team new quote' Template in Mandrill)
  def new_caitredette_service_notice(req)
    @req = req
    mail(subject: "[team] New Caitredette Service Request Received")
  end

  # Previously Mailers::TeamPartnerConfirmationMail ('Team vendor confirmation' Template in Mandrill)
  def food_partner_confirmation_notice(enquiry)
    @enquiry = enquiry
    @food_partner = @enquiry.food_partner
    @customer = @enquiry.customer
    mail(subject: "[team] #{@food_partner.company_name} confirmed order #{@enquiry.id}")
  end

  # Previously Mailers::TeamNewPartnerEnquiryMail ('Team new vendor' Template in Mandrill)
  def new_partnership_potential(form_params)
    @form_params = form_params
    mail(subject: "[team] New Partnership Potential")
  end

end
