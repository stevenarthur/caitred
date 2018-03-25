class AddDeliveryDaysToFoodPartners < ActiveRecord::Migration
  def change
  	add_column :food_partners, :delivery_days, :string
    add_column :food_partners, :delivery_hours, :json
  end
end
