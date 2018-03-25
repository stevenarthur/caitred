class ChangeFoodArtisanToFoodPartners < ActiveRecord::Migration
  def change
    rename_column :enquiries, :food_artisan_id, :food_partner_id
    rename_column :delivery_hours, :food_artisan_id, :food_partner_id
    rename_column :menus, :food_artisan_id, :food_partner_id
    rename_column :packageable_items, :food_artisan_id, :food_partner_id
    rename_column :quotes, :food_artisan_id, :food_partner_id
    rename_column :requests, :food_artisan_id, :food_partner_id
    rename_column :supplier_communications, :food_artisan_id, :food_partner_id
    rename_column :delivery_areas_food_artisans, :food_artisan_id, :food_partner_id
    rename_table :delivery_areas_food_artisans, :delivery_areas_food_partners
    rename_table :food_artisans, :food_partners
  end
end
