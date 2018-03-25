class AddAddressToFoodArtisans < ActiveRecord::Migration
  def change
    add_column :food_artisans, :address_line_1, :string
    add_column :food_artisans, :address_line_2, :string
    add_column :food_artisans, :suburb, :string
    add_column :food_artisans, :postcode, :string
  end
end
