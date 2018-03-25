class AddPriceRangeCheckboxesToFoodArtisans < ActiveRecord::Migration
  def change
    add_column :food_artisans, :price_low, :boolean, default: false
    add_column :food_artisans, :price_medium, :boolean, default: false
    add_column :food_artisans, :price_high, :boolean, default: false
  end
end
