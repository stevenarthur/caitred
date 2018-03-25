class AddEventTypeToFoodPartner < ActiveRecord::Migration
  def change
    add_column :food_partners, :event_type, :text, array: true, default: []
    FoodPartner.find_each do |partner|
      types = partner.packageable_items.pluck(:event_type).flatten.uniq
      partner.event_type = types
      partner.save
    end
  end
end
