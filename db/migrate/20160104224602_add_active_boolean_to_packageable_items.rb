class AddActiveBooleanToPackageableItems < ActiveRecord::Migration
  def change
    add_column :packageable_items, :active, :boolean, default: false
  end
end
