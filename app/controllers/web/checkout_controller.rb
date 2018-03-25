class Web::CheckoutController < WebsiteController 

  # Order Form
  def new
    @enquiry = current_enquiry
    @food_partner = @enquiry.food_partner
    unless current_enquiry.status == "Pending Payment"

      assign_date_and_time_to_enquiry_and_session

      @enquiry.build_customer
      @enquiry.build_address
      check_partner_delivers_to_postcode
      check_partner_lead_time_okay
      check_partner_delivers_on_day_and_at_time
      redirect_to partner_from_web_path(@food_partner.url_slug) and return if flash[:error].present?
    end
  end

  def assign_date_and_time_to_enquiry_and_session
    date = params[:enquiry][:event_date]
    time = params[:enquiry][:event_time]
    postcode = params[:enquiry][:postcode]

    @enquiry.event_date = date
    @enquiry.event_time = time

    session[:delivery_day] = date
    session[:eat_time] = time
    session[:postcode] = postcode
  end

  # Payment Form
  def payment
    @enquiry = current_enquiry
    @food_partner = @enquiry.food_partner
    begin
      find_or_create_customer
      create_enquiry
    rescue
      @enquiry.build_customer
      @enquiry.build_address
      render :new
    end
  end

  # Purchase
  def create
    @enquiry = current_enquiry
    @stripe_card_token = params[:stripe_card_token]
    if @enquiry.save_with_payment(@stripe_card_token)
      ProcessOrderJob.perform_later(@enquiry.id)
      redirect_to thanks_path
    else
      @enquiry = current_enquiry
      @food_partner = @enquiry.food_partner
      flash[:error] = "There was an error submitting your order. Please try again"
      render :payment
    end
  end

  def thanks
    @customer = Customer.find(session[:customer_id])
    @enquiry = current_enquiry
    session.delete(:enquiry_id)
  end

private

  def check_partner_delivers_to_postcode
    postcode = current_enquiry.address.try(:postcode) || params[:enquiry][:postcode]
    if !postcode.present?
      flash[:error] = "You must have selected a postcode"
    elsif !@food_partner.postcodes.pluck(:zipcode).include?(postcode)
      flash[:error] = "Sorry, #{@food_partner.company_name} does not deliver to this area"
    end
  end

  def check_partner_delivers_at_time
    time = params[:enquiry][:event_time]
    if !time.present?
      flash[:error] = "You must have selected an eat time"
    end
  end

  def check_partner_delivers_on_day
    date = params[:enquiry][:event_date]
    if !date.present?
      flash[:error] = "You must have selected an event date"
    end
  end

  def check_partner_lead_time_okay
    time = params[:enquiry][:event_time]
    date = params[:enquiry][:event_date]
    if time.present? && date.present?
      minimum_order_time = Time.current + (@food_partner.lead_time_hours).hours
      @enquiry.event_date = date
      @enquiry.event_time = time
      unless @enquiry.event_date_and_time >= minimum_order_time
        flash[:error] = "This food partner requires a lead time of 24 hours or more"
      end
    end
  end

  def find_or_create_customer
    return @customer = Customer.find(customer_id) unless customer_id.blank?
    @customer = Customer.find_by_email(customer_params[:email]) || Customer.new
    @customer.update_attributes! customer_params
    session[:customer_id] = @customer.id
  end

  def customer_id
    params[:enquiry][:customer_id]
  end

  def customer_params
    params.require(:enquiry)
      .require(:customer)
      .permit(*Factories::CustomerFactory::ALLOWED_PARAMS)
  end

  def create_enquiry
    @enquiry = current_enquiry
    @enquiry.assign_attributes enquiry_params
    @enquiry.customer = @customer
    @enquiry.status = EnquiryStatus::PENDING_PAYMENT
    create_address
    @enquiry.populate_from_enquiry_items
    @enquiry.save!
  end
  
  def enquiry_params
    return {} if params[:enquiry].nil?
    params.require(:enquiry).permit(*Factories::EnquiryFactory::ALLOWED_PARAMS)
  end

  def create_address
    return unless address_details_populated?
    if address_id.blank?
      @address = Address.create!(address_params)
    else
      @address = Address.find address_id
      @address.update_attributes!(address_params)
    end
    @enquiry.address = @address
  end

  def check_partner_delivers_on_day_and_at_time
    time = params[:enquiry][:event_time]
    date = params[:enquiry][:event_date]
    if !time.present? || !date.present?
      flash[:error] = "This food partner does not deliver on this date at this time." 
      return false
    end

    unless @food_partner.open_on_and_delivers_at?(@enquiry.event_date_and_time)
      flash[:error] = "This food partner does not deliver on this date at this time." 
    end
  end

  def address_details_populated?
    return false if address_params.empty?
    address_params.any? do |key, val|
      key != 'customer' && !val.blank?
    end
  end

  def address_id
    params[:enquiry][:address_id]
  end

  def address_params
    return {} if params[:enquiry].nil? || params[:enquiry][:address].nil?
    address_properties = params.require(:enquiry)
                         .require(:address)
                         .permit(Address.allowed_params)
    address_properties[:customer] = @customer
    address_properties
  end

end
