class AddFeaturedVendorImageToFoodArtisan < ActiveRecord::Migration
  def change
    add_column :food_artisans, :featured_image_file_name, :string
  end
end
