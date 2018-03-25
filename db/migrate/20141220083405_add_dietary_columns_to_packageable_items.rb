class AddDietaryColumnsToPackageableItems < ActiveRecord::Migration
  def change
    add_column :packageable_items, :vegetarian, :boolean
    add_column :packageable_items, :vegan, :boolean
    add_column :packageable_items, :gluten_free, :boolean
  end
end
