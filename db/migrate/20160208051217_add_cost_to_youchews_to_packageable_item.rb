class AddCostToYouchewsToPackageableItem < ActiveRecord::Migration
  def up
    add_column :packageable_items, :cost_to_youchews, :decimal, precision: 8, scale: 2
  end

  def down
    remove_column :packageable_items, :cost_to_youchews
  end
end
