class FoodPartner < ActiveRecord::Base
  include Cake::Money
  include CakeModel
  has_many :enquiries
  has_many :packageable_items
  has_many :menu_categories
  has_many :supplier_communications
  has_many :quotes
  has_many :testimonials
  has_many :delivery_hours, dependent: :destroy, inverse_of: :food_partner

  has_many :food_partner_delivery_postcodes
  has_many :postcodes, through: :food_partner_delivery_postcodes

  has_and_belongs_to_many :delivery_areas #, :through => :food_partners_areas

  accepts_nested_attributes_for :delivery_hours, allow_destroy: true

  validates :minimum_spend,
            numericality: { only_integer: false, allow_nil: true }
  validates :maximum_attendees,
            numericality: { only_integer: true, allow_nil: true }
  validates :delivery_cost,
            numericality: { only_integer: false, allow_nil: true }
  validates :lowest_price_dish,
            numericality: { only_integer: false, allow_nil: true }
  validates :lead_time_hours,
            numericality: { only_integer: true, allow_nil: true }
  validates :orders_per_week,
            numericality: { only_integer: true, allow_nil: true }
  validates :url_slug, format: { without: /[^a-zA-Z0-9_-]/ }
  validates :priority_order, presence: true, numericality: { only_integer: true }

  scope :for_attendees, lambda {|attendees|
    where('? <= maximum_attendees', attendees)
  }
  scope :alphabetical, -> { order(:company_name) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :ready_in_less_than, -> (nb_days) { where('lead_time_hours <= ?', nb_days) }

  scope :order_by_priority, -> { order(priority_order: :asc) }
  scope :by_event_type, -> (event_type) { where("? = ANY (event_type)", event_type) }

  scope :in_postcode, -> (postcode) do 
    joins(:postcodes).where(postcodes: { zipcode: postcode }).group("food_partners.id")
  end

  # Looks for partners that deliver at a given time. Looks for "4 PM" 
  # THIS JUST CHECKS WHETHER IT'S EVER OPEN AT 4PM OR SIMILAR
  scope :deliver_at, -> (string_time) do
    joins(:delivery_hours)
      .where('? BETWEEN start_time AND end_time', DeliveryHour.string_to_seconds(string_time))
        .group("food_partners.id")
  end

  # Looks for partners that are ever open on a given day. 
  # THIS JUST CHECKS WHETHER IT'S OPEN ON A MONDAY OR A TUESDAY 
  scope :open_on, -> (date_or_datetime) do
    lowercase_day_name = date_or_datetime.strftime("%A").downcase
    integer_day = DeliveryHour.days[lowercase_day_name]
    joins(:delivery_hours).where(delivery_hours: { day: integer_day }).group("food_partners.id")
  end

  # Looks for partners that are open at a given dattime
  scope :open_on_and_delivers_at, -> (datetime) do
    integer_day = DeliveryHour.days[datetime.strftime("%A").downcase]
    joins(:delivery_hours).where(delivery_hours: { day: integer_day })
                          .where('? BETWEEN start_time AND end_time', datetime.seconds_since_midnight)
                          .group("food_partners.id")
  end

  # The main scope to use
  scope :available_to_purchase_at, -> (datetime) do
    hours_away_from_now = ((datetime - Time.zone.now) / 60.0 / 60.0)
    active.open_on_and_delivers_at(datetime).where("lead_time_hours <= ?", hours_away_from_now)
  end

  mount_uploader :image_file_name, ImageUploader
  mount_uploader :featured_image_file_name, ImageUploader

  cake_model do
    generate_url_from :company_name
  end

  PROPERTIES = [
    :company_name,
    :quick_description,
    :email,
    :phone_number,
    :contact_first_name,
    :contact_last_name,
    :image_file_name,
    :secondary_email, 
    :minimum_spend,
    :maximum_attendees,
    :delivery_cost,
    :delivery_text,
    :availability_text,
    :url_slug,
    :need_to_know,
    :lead_time_hours,
    :lowest_price_dish,
    :orders_per_week,
    :bio,
    :category,
    :active,
    :delivery_days,
    :address_line_1,
    :address_line_2,
    :suburb,
    :postcode,
    delivery_hours_attributes: [:start_time, :end_time]
  ]

  DELIVERY_DAYS = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ]

  def email_recipients
    if secondary_email.present?
      ["\"#{contact_first_name}\" <#{email}>",
       "\"#{secondary_contact_first_name}\" <#{secondary_email}>"]
    else
      %("#{contact_first_name}" <#{email}>)
    end
  end

  def email?
    !(email.nil? || email.blank?)
  end

  def phone?
    !(phone_number.nil? || phone_number.blank?)
  end

  def self.allowed_params
    PROPERTIES
  end

  def contact_name
    [contact_first_name, contact_last_name].join(' ').strip
  end

  def image_path
    if image_file_name?
      image_file_name
    else
      'restaurant.jpg'
    end
  end

  def lead_time_in_days
    lead_time_hours.to_i / 24
  end

  def minimum_order_date
    (DateTime.now + lead_time_in_days).strftime("%m-%d-%Y")
  end

  def self.ready_by date 
    future = Time.parse(date)
    difference_in_days = ((future - Time.now) / 1.hour).round
    FoodPartner.ready_in_less_than(difference_in_days)
  end

  def available_delivery_times_for_day(date)
    delivery_hours.map{ |hours| hours.selectable_times }.flatten.uniq.sort
                  .map { |time| time.strftime("%l:%M %p").strip }
  end

  def self.available_delivery_times_for_day(date)
    available_hours = DeliveryHour.joins(:food_partner).where(:food_partners => { active: true })
    available_hours.map{ |hours| hours.selectable_times }.flatten.uniq.sort
                   .map { |time| time.strftime("%l:%M %p").strip }
  end

  def open_on? date_or_datetime
    delivery_hours.pluck(:day).include? date_or_datetime.strftime("%w").to_i
  end

  # does this partner EVER deliver at a given time?
  def delivers_at? string_time
    delivery_hours.where('? BETWEEN start_time AND end_time', 
      DeliveryHour.string_to_seconds(string_time)).present?
  end

  def open_on_and_delivers_at? datetime
    integer_day = DeliveryHour.days[datetime.strftime("%A").downcase]
    delivery_hours.where(day: integer_day)
                  .where('? BETWEEN start_time AND end_time', datetime.seconds_since_midnight).present?
  end

  def available_to_purchase_at? datetime 
    hours_away_from_now = ((datetime - Time.zone.now) / 60.0 / 60.0)
    active? && open_on_and_delivers_at?(datetime) && (lead_time_hours <= hours_away_from_now)
  end

end
