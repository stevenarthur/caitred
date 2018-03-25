class AddSecondaryEmailToFoodPartner < ActiveRecord::Migration
  def change
    add_column :food_partners, :secondary_email, :string
  end
end
