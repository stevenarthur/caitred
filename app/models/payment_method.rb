class PaymentMethod
  attr_reader :name, :xero_template, :payment_fee_description, :gst_included

  def initialize(name, xero_template, payment_fee_description, gst_included = true)
    @name = name
    @xero_template = xero_template
    @payment_fee_description = payment_fee_description
    @gst_included = gst_included
  end

  def to_s
    @name
  end

  def self.find(name)
    [
      CREDIT_CARD,
      SINGLE_EFT_INVOICE,
      PAYPAL_INVOICE,
      MONTHLY_EFT_INVOICE
    ].find { |payment| payment.name == name }
  end

  CREDIT_CARD = PaymentMethod.new(
    'Credit Card',
    ENV['XERO_PAID_BRAND_THEME'],
    'Credit Card'
  )

  SINGLE_EFT_INVOICE = PaymentMethod.new(
    'Single Invoice (pay by EFT)',
    ENV['XERO_EFT_THEME'],
    'EFT'
  )

  PAYPAL_INVOICE = PaymentMethod.new(
    'Single Invoice (pay by Paypal)',
    ENV['XERO_PAYPAL_BRAND_THEME'],
    'Paypal',
    false
  )

  MONTHLY_EFT_INVOICE = PaymentMethod.new(
    'Monthly Invoice (pay by EFT)',
    ENV['XERO_EFT_THEME'],
    'EFT'
  )
end
