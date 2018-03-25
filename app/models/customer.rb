require 'authlogic/crypto_providers/bcrypt'

class Customer < ActiveRecord::Base

  acts_as_authentic do |config|
    config.login_field = 'email'
    config.logged_in_timeout = 1.month.to_i
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.validate_email_field = false
    config.validate_password_field = false
    config.ignore_blank_passwords  = true
  end

  before_save :downcase_email

  has_many :enquiries
  has_many :addresses
  validates :email,
            presence: true,
            uniqueness: { judge: :ignore},
            format: { with: Authlogic::Regex.email  }

  #validates :company_name, presence: true
  #validates :password, presence: true, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :telephone, presence: true

  scope :by_email, ->(email) { where('email = ?', email) }
  scope :unregistered, -> { where('created_account = false') }
  scope :registered, -> { where('created_account = true') }
  scope :by_name, lambda {|first_name, last_name|
    where('? = first_name and ? = last_name', first_name, last_name)
  }

  serialize :preferences, Preferences


  def self.find_by_email(email)
    return nil if email.nil? || email.empty?
    Customer.by_email(email).first
  end

  def name
    "#{first_name} #{last_name}"
  end

  def additional_name
    "#{additional_first_name} #{additional_last_name}"
  end

  def description
    return '' if id.nil?
    "#{first_name} #{last_name} (#{email_string})"
  end

  def as_json(options = {})
    h = super(options)
    h[:description] = description
    h
  end

  def default_address
    addresses.where(default: true).first ||
      addresses.first
  end

  def addresses?
    return :none if addresses.count == 0
    addresses.count == 1 ? :one : :many
  end

  def default_address=(address)
    default_address.update_attributes! default: false
    address.update_attributes! default: true
  end

  def create_session
    session = Authentication::CustomerSession.new(
      #email: self.email,
      #password: ''
      self
    )
    session.save!
  end

  def self.create_with_linkedin(auth)
    password = (0...8).map { (65 + rand(26)).chr }.join
    @customer = Customer.create(
      first_name: auth['info']['first_name'], 
      last_name: auth['info']['last_name'], 
      email: auth['info']['email'], 
      provider: 'linkedin',
      password: password,
      password_confirmation: password )
    @current_customer_session = Authentication::CustomerSession.new(
      email: @customer.email,
      password: password
    )
    @current_customer_session.save!
    @customer
  end


private

  def downcase_email
    email.downcase if email.present? 
  end

  def company_string
    company_name.nil? ? 'no company' : company_name
  end

  def email_string
    email.nil? ? 'no email' : email
  end
end
