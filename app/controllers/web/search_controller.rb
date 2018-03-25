class Web::SearchController < WebsiteController

  before_filter :by_postcode, only: [:show]
  before_filter :check_postcode, only: [:create]

  def show
    assign_search_to_session
    find_postcode
    session[:postcode] = @postcode.zipcode
    @food_partners = FoodPartner.in_postcode(@postcode.zipcode).order_by_priority.active
  end

  def search
    advanced_search
    assign_search_to_session
    render "search", layout: false
  end

  def update_enquiry_parameters
    session[:delivery_day] = params[:enquiry][:delivery_day] if params[:enquiry][:delivery_day].present?
    session[:eat_time] = params[:enquiry][:eat_time] if params[:enquiry][:eat_time].present?
    if params[:enquiry][:postcode].present?
      session[:postcode] = params[:enquiry][:postcode] 
      session[:locality] = Postcode.find_by_zipcode(params[:enquiry][:postcode]).try(:slug)
    end
    current_enquiry.event_date = session[:delivery_day] if session[:delivery_day].present?
    current_enquiry.event_time = session[:eat_time] if session[:eat_time].present?
    head :ok
  end

  # Used from homepage to convert the postcode to the locality
  # Here, we want to check if any vendors actually exist and return an error if not?
  def create
    find_locality 
    if @locality.present?
      @food_partners = FoodPartner.active.in_postcode(@locality.zipcode)
    end

    if @locality.present? && @food_partners.present?
      json_response = { "partner_count": @food_partners.count }.to_json
      respond_to do |format|
        format.html{ redirect_to partner_search_path(forwarded_params) }
        format.js { render :js => "window.location = '#{partner_search_path(@locality.slug)}'" }
        format.json { render json: json_response, status: :created }
      end
    else
      respond_to do |format|
        json_response = { "partner_count": 0, "postcode": @locality.try(:zipcode) }.to_json
        format.html{ redirect_to new_quote_path(), notice: "Sorry, we don't currently service your postcode - though we still may be able to help. Submit a query below:" }
        format.js { render json: json_response, status: :unprocessable_entity }
        format.json { render json: json_response, status: :unprocessable_entity }
      end
    end
  end

private
  def find_locality
    if params[:slug].present?
      @locality = Postcode.friendly.find(params[:slug])
    else
      @locality = Postcode.find_by(zipcode: params[:postcode])
    end
  end

  def assign_search_to_session
    session[:postcode] = params[:postcode] if params[:postcode].present?
    session[:delivery_day] = params[:date] if params[:date].present?
    session[:eat_time] = params[:eat_time] if params[:eat_time].present?
    session[:price_low] = params[:price_low] if params[:price_low].present?
    session[:price_medium] = params[:price_medium] if params[:price_medium].present?
    session[:price_high] = params[:price_high] if params[:price_high].present?
    session[:event_type] = params[:event_type] if params[:event_type].present?
    session[:locality] = params[:locality] if params[:locality].present?
  end

  def by_postcode
    @food_partners = FoodPartner.in_postcode(params[:locality] || session[:postcode]).active
  end

  def check_postcode
    unless Postcode.where(slug: params[:slug]).present? || Postcode.where("zipcode ILIKE ?", params[:postcode])
      flash[:error] = "No results? We still may be able to help you \"chews\" - if you have 10 or more people to feed in greater Sydney, please place an enquiry here and our Chewsy Crew will be in touch ASAP."
      return redirect_to new_quote_path
    end
  end

  def advanced_search
    @food_partners = FoodPartner.active
    @food_partners = @food_partners.order(params[:sort]) if params[:sort].present?
    @food_partners = @food_partners.order("company_name" => params[:direction]) if params[:direction].present? && !params[:sort].present?
    @food_partners = @food_partners.order("ASC") if !params[:direction].present? && !params[:sort].present?
    @food_partners = @food_partners.in_postcode(params[:postcode]) if params[:postcode].present?
    @food_partners = @food_partners.where("price_low = ? ", params[:price_low]).group("id") if params[:price_low].present?
    @food_partners = @food_partners.where("price_medium = ? ", params[:price_medium]).group("id") if params[:price_medium].present?
    @food_partners = @food_partners.where("price_high = ? ", params[:price_high]).group("id") if params[:price_high].present?
    @food_partners = @food_partners.by_event_type(params[:event_type]) if params[:event_type].present?

    if params[:date].present? && params[:eat_time].present?
      combined_datetime = Time.zone.parse("#{params[:date]} #{params[:eat_time]}")
      @food_partners = @food_partners.available_to_purchase_at(combined_datetime)
    elsif params[:date].present?
      date = Time.zone.parse(params[:date])
      @food_partners = @food_partners.open_on(date)
    elsif params[:eat_time].present?
      @food_partners = @food_partners.deliver_at(params[:eat_time])
    end

    @food_partners = @food_partners.group('food_partners.id')
  end

private
  def postcode_or_locality_present?
    params[:locality].present? || params[:postcode].present?
  end

  def find_postcode
    if postcode_or_locality_present?
      @postcode = Postcode.friendly.find(params[:locality]) if params[:locality].present?
      @postcode = Postcode.find_by_zipcode(params[:postcode]) if params[:postcode].present?
    else
      @postcode = Postcode.friendly.find('sydney-city')
    end
  end

end
