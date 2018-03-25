class AddBioToFoodPartners < ActiveRecord::Migration
  def change
    add_column :food_partners, :bio, :text
    add_column :food_partners, :category, :string
    add_column :food_partners, :active, :boolean, :default => FALSE
  end
end
