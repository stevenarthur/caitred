module ForFoodPartner
  extend ActiveSupport::Concern

  def find_food_partner
    id = params[:food_partner_id] || params[:id]
    @food_partner = FoodPartner.find_by_id(id)
  end

end
