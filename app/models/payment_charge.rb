class PaymentCharge
  def initialize(enquiry, request, token)
    @enquiry = enquiry
    @request = request
    @token = token
  end

  def post_params
    {
      email: @enquiry.customer.email,
      description: "Catering by Caitre'd - Order #{@enquiry.id}",
      ip_address: @request.remote_ip,
      amount: cents(@enquiry.amount_to_pay),
      currency: 'AUD',
      card_token: @token
    }
  end

  def post_params_string
    post_params.map do |key, value|
      "#{key}=#{value}"
    end.join(';')
  end

  def cents(amount)
    (amount * 100).to_i
  end
end
