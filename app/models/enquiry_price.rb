class EnquiryPrice

  PAYMENT_PROVIDER_BASE_COST = 0.3
  PAYMENT_PROVIDER_CHARGE = 0.018

  STRIPE_BASE_COST = 0.3
  STRIPE_CHARGE = 0.029

  PAYPAL_BASE_COST = 0.3
  PAYPAL_CHARGE = 0.024

  def initialize(enquiry)
    @enquiry = enquiry
  end

  def food_cost
    @enquiry.enquiry_items.to_a.sum(&:total_price)
  rescue
    0
  end

  # For cart system
  def populate_price_from_cart
    @enquiry.delivery_cost = @enquiry.food_partner.delivery_cost.to_f
    @enquiry.delivery_cost_to_us = @enquiry.delivery_cost.to_f
    @enquiry.total_cost = food_cost + @enquiry.delivery_cost
  end


  def populate_total_price!
    @enquiry.update_attributes!(
      total_cost: food_cost + @enquiry.delivery_cost.to_f,
      total_cost_to_us: @enquiry.delivery_cost_to_us.to_f + food_cost_to_us
    )
  end

  def payment_fee
    actual_payment_fee
  end

  def food_and_delivery_cost
    food_cost + @enquiry.delivery_cost
  end

  def amount_to_pay
    (food_and_delivery_cost + payment_fee).to_f.round(2)
  end

  def record_amount_paid!
    @enquiry.update_attributes!(
      total_amount_paid: amount_to_pay,
      payment_fee_paid: actual_payment_fee,
      paid: true
    )
  end

  def payment_method_includes_gst?
    payment_method.gst_included
  end

  def gst_paid_to_supplier
    populate_total_price! if @enquiry.total_cost.nil?
    (@enquiry.total_cost_to_us.to_f - (@enquiry.total_cost_to_us.to_f / 1.1)).round(2)
  end

  def supplier_food_cost
    (food_cost * 0.85)
  end

  def supplier_delivery_cost
    (@enquiry.food_partner.delivery_cost * 0.85)
  end

private

  def actual_payment_fee
    populate_total_price! if @enquiry.total_cost.nil?
    case @enquiry.payment_method
    when PaymentMethod::CREDIT_CARD.to_s
      credit_card_fee.to_f.round(2)
    when PaymentMethod::PAYPAL_INVOICE.to_s
      paypal_fee.to_f.round(2)
    else
      0
    end
  end

  def payment_method
    PaymentMethod.find(@enquiry.payment_method)
  end

  def paypal_fee
    (PAYPAL_BASE_COST +
      (food_and_delivery_cost * PAYPAL_CHARGE))
  end

  def credit_card_fee
    (STRIPE_BASE_COST + (food_and_delivery_cost * STRIPE_CHARGE))
  end

  def food_cost_to_us
    cost_to_youchews = 0
    @enquiry.enquiry_items.each do |i|
      cost_to_youchews = cost_to_youchews + ( i.packageable_item.cost_to_youchews * i.quantity )
    end
    cost_to_youchews
  rescue
    0
  end

end
