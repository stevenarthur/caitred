class TeamMailerPreview < ActionMailer::Preview

  def new_order_notice
    enquiry = Enquiry.find(3047)
    TeamMailer.new_order_notice(enquiry)
  end

  def new_quote_notice
    quote = Quote.last
    TeamMailer.new_quote_notice(quote)
  end

  def food_partner_confirmation_notice
    enquiry = Enquiry.find(3047)
    TeamMailer.food_partner_confirmation_notice(enquiry)
  end

  def new_partnership_potential
    form_params = {
      name: 'Paul Millar',
      email: 'paul@digitaldawn.com.au',
      phone: '0425616397',
      company_name: 'Digital Dawn',
      more_info: 'We cook code',
      website: 'https://www.digitaldawn.com.au',
      delivery: 'Yes' }
    TeamMailer.new_partnership_potential(form_params)
  end

end
