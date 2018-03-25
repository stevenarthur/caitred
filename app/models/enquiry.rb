class Enquiry < ActiveRecord::Base
  include Cake::HasPrice

  belongs_to :food_partner
  belongs_to :customer
  belongs_to :address
  has_many :supplier_communications
  has_many :status_audits
  has_many :enquiry_codes

  # Line items
  has_many :enquiry_items

  serialize :event, EventDetails
  serialize :logistics, Logistics
  serialize :dietary_requirements, DietaryRequirements

  scope :awaiting_confirmation, -> { where(status: EnquiryStatus.awaiting_confirmation) }
  scope :awaiting_completion, -> { where(status: EnquiryStatus.awaiting_completion) }
  scope :completed, -> { where(status: EnquiryStatus::COMPLETED) }
  scope :cancelled, -> { where(status: EnquiryStatus::CANCELLED) }
  scope :pending_payment, -> { where(status: EnquiryStatus::PENDING_PAYMENT) }
  scope :in_cart, -> { joins(:enquiry_items).pending_payment
                                            .where("enquiries.id >= 834").group("enquiries.id") }
  scope :placed_today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
                            .where(status: [EnquiryStatus::COMPLETED, EnquiryStatus::DELIVERED, 
                                            EnquiryStatus::CONFIRMED, EnquiryStatus::READY_TO_CONFIRM, 
                                            EnquiryStatus::WAITING_ON_SUPPLIER, EnquiryStatus::PROCESSING]) }

  before_create :set_address
  after_save :create_status_audit
  REMINDER_TIME = 120.minutes

  delegate :company_name, 
           :minimum_spend, to: :food_partner, prefix: true, allow_nil: true

  delegate :email, 
           :name, 
           :company_name,
           :telephone, 
           :additional_first_name, 
           :additional_last_name, 
           :additional_name, 
           :additional_telephone, to: :customer, prefix: true

  delegate :food_cost,
           :populate_total_price!,
           :payment_fee,
           :amount_to_pay,
           :total_gst,
           :total_extras,
           :food_and_delivery_total_including_gst,
           :record_amount_paid!,
           :gst_on_food_and_delivery,
           :food_total_including_gst,
           :delivery_including_gst,
           :payment_method_includes_gst?,
           :gst_paid_to_supplier,
           :supplier_food_cost,
           :supplier_delivery_cost,
           to: :enquiry_price

  delegate :ready_to_confirm?, :create_confirm_link, to: :enquiry_confirmation

  def save_with_payment(stripe_card_token)
    if valid?
      if !self.stripe_payment_id.present?
        ActiveRecord::Base.transaction do
          self.record_amount_paid!
          customer = Stripe::Customer.create(
            description: self.customer.name, 
            email: self.customer.email, 
            card: stripe_card_token
          )
          self.stripe_customer_token = customer.id

          charge = Stripe::Charge.create(
            :customer    => customer.id,
            :amount      => (self.amount_to_pay.round(2) * 100).to_i,
            :description => "YC Order ##{self.id}",
            :currency    => 'aud'
          )
          self.status = EnquiryStatus::NEW
          self.stripe_payment_id = charge.id
          save!
        end
      else
        logger.error "This payment has already been processed"
        errors.add :base, "Your card has already been charged for this transaction."
      end
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def enquiry_price
    @enquiry_price ||= EnquiryPrice.new(self)
  end

  def enquiry_confirmation
    @enquiry_confirmation ||= EnquiryConfirmation.new(self)
  end

  #def menu
    #menu_json = self[:menu]
    #return nil if menu_json.nil?
    #Menu.new.from_json(menu_json.to_json)
  #end

  def menu_extras
    self[:menu_extras] || []
  end

  def status_value
    EnquiryStatus.value_of(status)
  end

  def method_missing(method_name, *args)
    if [:next_status, :last_status, :can_progress?, :can_regress?,
        :can_cancel?, :can_mark_test_or_spam?].include? method_name
      return EnquiryStatus.send(method_name, status)
    end
    super
  end

  # Used when cart is updated to update subtotals, delivery and payment totals
  def populate_from_enquiry_items
    if enquiry_items.present? # not present
      self.food_partner = enquiry_items.first.packageable_item.food_partner # cleanlol
      enquiry_price.populate_price_from_cart
    end
  end

  def populate_from_menu(menu)
    self.food_partner = menu.food_partner
    self.menu_title = menu.title
    enquiry_price.populate_price_from_menu(menu)
    self.customer_menu_content = menu.item_titles_content.truncate(255)
    save!
  end

  def customer_menu_html
    return '' if customer_menu_content.nil?
    customer_menu_content.gsub('\n', '<br>').gsub("\n", '<br>')
  end

  def event
    return self[:event] if self[:event].is_a? EventDetails
    EventDetails.new(self[:event])
  end

  def confirmed_date
    sql = "select created_at from completed_enquiries where enquiry_id=#{id}"
    confirmed = self.class.connection.select_values(sql)
    return nil if confirmed.empty?
    confirmed[0]
  end

  def ensure_processing
    EnquiryStatus.progress(self) if status == EnquiryStatus::NEW
    save!
  end

  def wait_on_supplier
    self.status = EnquiryStatus::WAITING_ON_SUPPLIER
    #EnquiryStatus.progress(self) if status == EnquiryStatus::PROCESSING
    save!
  end

  def post_confirmation?
    EnquiryStatus.post_confirmation?(status)
  end

  def token
    string = self.id.to_s + '-' + self.food_partner.company_name
    Digest::MD5.hexdigest(string)
  end

  def self.to_csv
    column_names = ['Order Date', 'Company Name', 'Menu Package name', 'Partner Name', 'Number of attendees', 'Unit Price', 'Total order', 'Status', 'Order #']
    CSV.generate do |csv|
      csv << column_names
      all.each do |enquiry|
        #menu = Menu.find(enquiry.attributes.values_at('menu')[0]['id'])
        black_list = [39, 36, 35, 31, 25, 22, 26, 34, 28, 13, 18]
        unless black_list.include?(enquiry.id)
          row = []
          row << enquiry.created_at
          row << enquiry.address.try(:company)
          row << enquiry.menu.try(:title)
          row << enquiry.food_partner.try(:company_name)
          row << enquiry.event.attendees
          row << enquiry.menu.try(:price)
          row << enquiry.total_cost
          row << enquiry.status
          row << enquiry.id
          csv << row
        end
      end
    end
  end

  def event_date_and_time
    Time.local(self.event_date.to_time.year, self.event_date.to_time.month, self.event_date.to_time.day, self.event_time.hour, self.event_time.min)
  end

  def delivery_time
    (event_time - 15.minutes).strftime("%l:%M %p")
  end

  def refund_customer
    payment = Stripe::Charge.retrieve(self.stripe_payment_id)
    payment.refunds.create unless payment['refunded']
    cancel_invoice if self.xero_invoice_id
  end

  def confirm_by_food_partner
    self.status = EnquiryStatus::CONFIRMED
    self.save!
    if !xero_invoice_id.present?
      GenerateInvoiceWorker.perform_async(self.id)
      GenerateSupplierInvoiceWorker.perform_async(self.id)
    end
  end
  
  def subtotal
    enquiry_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  def formatted_line_items_for_menu_details
    formatted = "" 
    enquiry_items.each do |item|
      formatted += "#{item.quantity} x #{item.packageable_item.title} - #{number_to_currency(item.packageable_item.cost_to_youchews)}".strip
      formatted += "\n"
    end
    return formatted
  end

  def formatted_line_items_for_partner
    formatted = "" 
    enquiry_items.each do |item|
      formatted += "#{item.quantity} x #{item.packageable_item.title} @ #{number_to_currency(item.packageable_item.cost)} each".strip
      formatted += "&#10;"
    end
    return formatted
  end

  def formatted_line_items_for_customer
    formatted = "" 
    enquiry_items.each do |item|
      formatted += "#{item.quantity} x #{item.packageable_item.title} - #{number_to_currency(item.packageable_item.cost)}".strip
      formatted += "&#10;"
    end
    return formatted
  end

  def partner_reminder_due?
    return false if self.partner_reminder_sent?
    event_day = self.event_date_and_time
    day_before = (self.event_date_and_time - 24.hours).beginning_of_day
    day_before_3pm = day_before + 15.hours
    day_before_3pm <= Time.current
  end

  def feedback_email_due?
    return false if self.feedback_email_sent?
    (self.event_date_and_time + 24.hours) <= Time.current
  end

private

  # rubocop:disable Style/RedundantSelf
  def create_status_audit
    StatusAudit.create!(
      enquiry: self,
      old_status: status_change[0],
      new_status: status_change[1]
      ) if status_changed?
  end

  def cancel_invoice
    invoice = Xero::XeroClient.client.Invoice.find(self.xero_invoice_id)
    invoice.status = 'VOIDED'
    invoice.save
  end

  def set_address
    self.address = customer.default_address if address.nil? && customer.present?
  end
  # rubocop:enable Style/RedundantSelf
end
