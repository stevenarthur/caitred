# Migrates the legacy Menu Packages to PackageableItems.
class MigrateMenuPackagesToPackageableItems < ActiveRecord::Migration

  def up
    remove_column :packageable_items, :cost_as_extra
    add_column :packageable_items, :xero_item_id, :string
    add_column :packageable_items, :what_you_get, :text
    add_column :packageable_items, :presentation, :string
    add_column :packageable_items, :package_conditions, :string
    change_column :packageable_items, :description, :string, :limit => 500
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
