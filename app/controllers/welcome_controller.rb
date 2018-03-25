class WelcomeController < WebsiteController
  layout :resolve_layout
  http_basic_authenticate_with name: "oliver", 
                               password: "sharktank", only: [:oliver]

  def index
    @investment_lead = InvestmentLead.new
    @postcode_lead = PostcodeLead.new
  end
  
  def postcode_lookup
    if query_a_number?(params[:query])
      @postcodes = Postcode.limit(5).where("zipcode LIKE ?", "#{params[:query]}%")
    else
      @postcodes = Postcode.limit(5).where("slug ILIKE ?", "#{params[:query]}%")
    end
    respond_to do |format|
      format.js { render json: { "suggestions": @postcodes.as_json }.to_json }
      format.json { render json: { "suggestions": @postcodes.as_json }.to_json }
    end
  end

  def contest
  	@contact = Contact.new	
  end

  def share
  end

  def oliver
  end

private
  def query_a_number?(query)
    /^\d{3,4}$/ === query
  end

  def resolve_layout
    if params[:action] == 'oliver'
      return false
    else
      return 'website'
    end
  end

end
