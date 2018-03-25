# encoding: UTF-8

module EnquiryHelper
  BEVERAGE_OPTIONS = [
    'None',
    'Tea and Coffee',
    'Juice',
    'Alcoholic drinks'
  ]

  ATTENDEE_NUMBERS = [
    'Certainty unknown',
    '90%+ certain',
    '50%+ certain',
    'Less than 50% certain'
  ]

  def self.time_options
    (0..23).map do |hour|
      hour_str = format('%02d', hour)
      ["#{hour_str}:00", "#{hour_str}:15", "#{hour_str}:30", "#{hour_str}:45"]
    end.flatten
  end

  def address_partial
    if @enquiry.address.nil?
      @enquiry.customer.addresses? == :none ? 'no_addresses' : 'no_address_set'
    else
      @enquiry.customer.addresses? == :one ? 'one_address' : 'multiple_addresses'
    end
  end

  def enquiry_form_url
    return admin_enquiries_path if @enquiry.id.nil?
    admin_enquiry_path(@enquiry)
  end

  def address_options
    @enquiry.customer.addresses.map do |address|
      address_text = [
        address.company,
        address.line_1,
        address.line_2,
        address.suburb,
        address.postcode
      ].delete_if(&:blank?).join(', ')
      [address_text, address.id]
    end
  end

  def food_partner_options
    FoodPartner.all.map do |partner|
      [partner.company_name, partner.id]
    end
  end

  def formatted_event_date
    @enquiry.event_date.try(:strftime, '%e %B %Y')
  end

  def payment_fee_type
    PaymentMethod.find(@enquiry.payment_method).try(:payment_fee_description)
  end

  def status_class
    "status-#{@enquiry.status.gsub(' ', '-').downcase}"
  end

  def budget_options
    [
      ['(per person)', ''],
      ['$6 - $10', '0,10'],
      ['$10 - $12', '10,12'],
      ['$12 - $15', '12,15'],
      ['$15+', '15, 100']
    ]
  end

  def down_case(string)
    string.downcase.strip.gsub ' ', '_'
  end

  def enquiry_is_paid?(enquiry)
    ["Confirmed", "Delivered", "Completed"].include?(enquiry.status)
  end

  def subpackage_item_without_parent_order?(item)
    item.subpackage_item? && 
      !item.enquiry.enquiry_items.where(packageable_item_id: item.packageable_item.parent_id).present?
  end


end
