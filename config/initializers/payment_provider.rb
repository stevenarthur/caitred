if Rails.env.production?
  Cake::Application.config.payment_provider = PaymentProviders::PinConnector.new
else
  # Cake::Application.config.payment_provider = PaymentProviders::PinConnector.new
  Cake::Application.config.payment_provider = PaymentProviders::TestPayment.new
end
