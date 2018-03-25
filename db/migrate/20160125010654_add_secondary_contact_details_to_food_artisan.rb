class AddSecondaryContactDetailsToFoodArtisan < ActiveRecord::Migration
  def change
    add_column :food_artisans, :secondary_contact_first_name, :string
    add_column :food_artisans, :secondary_contact_last_name, :string
    add_column :food_artisans, :secondary_phone_number, :string
  end
end
