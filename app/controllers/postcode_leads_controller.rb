class PostcodeLeadsController < WebsiteController

  def create
    @investment_lead = PostcodeLead.new(permitted_params)
    if @investment_lead.save
      respond_to do |format|
        format.html { redirect_to root_path, error: "Thanks for your interest!" }
        format.js   { render json: @investment_lead.to_json(only: :created), status: :created}
        format.json { render json: @investment_lead.to_json(only: :created), status: :created}
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, error: "There was a problem submitting your interest. Please try again or alternatively give us a call!" }
        format.js   { render json: @investment_lead.errors, status: :unprocessable_entity}
        format.json { render json: @investment_lead.errors, status: :unprocessable_entity}
      end
    end
  end

private
  def permitted_params
    params.require(:postcode_lead).permit(:email, :postcode)
  end


end
