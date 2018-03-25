class FoodPartnersController < AdminController
  include ForFoodPartner

  before_action :find_food_partner, only: [:destroy, :edit, :update]
  before_action :require_admin_authentication

  def index
    @active_food_partners = FoodPartner.active.alphabetical
    @inactive_food_partners = FoodPartner.inactive.alphabetical
  end

  def new
    @food_partner = FoodPartner.new
    @delivery_hour = @food_partner.delivery_hours.build
    @delivery_areas = @food_partner.delivery_areas.build
  end

  def edit
    @delivery_hour = @food_partner.delivery_hours.first || @food_partner.delivery_hours.build
    @delivery_areas = @food_partner.delivery_areas
    @postcodes = Postcode.order(zipcode: :asc)
  end

  def create
    @food_partner = FoodPartner.create! food_partner_params
    @food_partner.delivery_area_ids = params[:food_partner][:delivery_areas] if params[:food_partner][:delivery_areas]
    flash[:success] = 'Food Partner Created'
    redirect_to edit_food_partner_path(@food_partner)
  end

  def destroy
    @food_partner.destroy
    flash[:success] = 'Food Partner Deleted'
    redirect_to food_partners_path
  end

  def update
    update_or_create_delivery_hours
    @food_partner.update_attributes! food_partner_params
    @food_partner.delivery_area_ids = params[:food_partner][:delivery_areas]
    flash[:success] = 'Food Partner updated'
    redirect_to edit_food_partner_path(@food_partner.id)
  end

  def add_postcode
    @food_partner = FoodPartner.find(params[:id])
    @postcode = Postcode.find_by(slug: params[:postcode_slug])
    @delivery_postcode = @food_partner.food_partner_delivery_postcodes
                                      .create!(postcode_id: @postcode.id)
    respond_to do |format|
      format.js
    end
  end

  def remove_postcode
    @food_partner = FoodPartner.find(params[:id])
    @delivery_postcode = @food_partner.food_partner_delivery_postcodes.find_by(postcode_id: params[:postcode])
    @delivery_postcode.destroy
    respond_to do |format|
      format.js
    end
  end

private
  def update_or_create_delivery_hours
    # if @delivery_hour = @food_partner.delivery_hours.first
    #   @delivery_hour.update_attributes(
    #     hour_start: params[:food_partner][:delivery_hours_attributes]["0"]["hour_start"], 
    #     hour_end:   params[:food_partner][:delivery_hours_attributes]["0"]["hour_end"])
    #   params[:food_partner].delete(:delivery_hours_attributes)
    # end
  end

  def food_partner_params
    params.require(:food_partner).permit(:company_name, :need_to_know, :quick_description, :email, :phone_number, :contact_first_name, :contact_last_name, :secondary_contact_first_name, :secondary_contact_last_name, :secondary_phone_number, :secondary_email, :image_file_name, :featured_image_file_name, :minimum_spend, :minimum_attendees, :maximum_attendees, :delivery_cost, :delivery_text, :availability_text, :url_slug, :lead_time_hours, :lowest_price_dish, :bio, :category, :priority_order, :active, :delivery_days, :price_low, :price_medium, :price_high, :address_line_1, :address_line_2, :suburb, :postcode, event_type: [], delivery_days: [], delivery_hours_attributes: [:day, :start_time, :end_time, :id, :_destroy])
  end
end
