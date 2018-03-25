class AddAdditionalOptionsToPackageableItem < ActiveRecord::Migration
  def change
    add_column :packageable_items, :vegetarian_options_available, :boolean, default: false
    add_column :packageable_items, :gluten_free_options_available, :boolean, default: false
  end
end
