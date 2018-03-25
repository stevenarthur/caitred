class AddSortOrderToPackagableItems < ActiveRecord::Migration
  def change
    add_column :packageable_items, :sort_order, :integer, default: 99, null: false
    PackageableItem.find_each do |item|
      item.update_attribute('sort_order', 99)
    end
  end
end
