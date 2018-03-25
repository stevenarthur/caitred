class AddMinimumOrderToPackageableItems < ActiveRecord::Migration
  def change
    add_column :packageable_items, :minimum_order, :integer, default: 1
    add_column :packageable_items, :maximum_order, :integer, default: 200
  end
end
