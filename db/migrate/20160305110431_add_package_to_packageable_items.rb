class AddPackageToPackageableItems < ActiveRecord::Migration
  def change
    add_column :packageable_items, :is_package, :boolean, default: false
    PackageableItem.all.find_each do |item|
      if item.package?
        item.is_package = true
        item.save
      end
    end
  end
end
