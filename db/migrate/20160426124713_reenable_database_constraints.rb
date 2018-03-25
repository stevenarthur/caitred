class ReenableDatabaseConstraints < ActiveRecord::Migration
  def change
    add_foreign_key :enquiries, :food_partners
    add_foreign_key :requests, :food_partners
    add_foreign_key :packageable_items, :food_partners
    add_foreign_key :supplier_communications, :food_partners
    add_foreign_key :menu_categories, :food_partners

    add_foreign_key :enquiry_items, :packageable_items
  end
end
