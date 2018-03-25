class AddFeaturedBooleanToFoodArtisan < ActiveRecord::Migration
  def change
    add_column :food_artisans, :priority_order, :integer, default: 999
  end
end
