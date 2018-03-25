class AddNeedToKnowToFoodPartner < ActiveRecord::Migration
  def change
    add_column :food_partners, :need_to_know, :text
  end
end
