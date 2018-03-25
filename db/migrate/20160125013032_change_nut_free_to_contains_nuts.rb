class ChangeNutFreeToContainsNuts < ActiveRecord::Migration
  def up
    rename_column :packageable_items, :nut_free, :contains_nuts
    # This should really be enabled, but has been disbaled as the data in the database
    # is currently pants
    #PackageableItem.find_each do |pa|
      #pa.update_attributes(contains_nuts: pa.contains_nuts)
    #end
  end
  def down
    rename_column :packageable_items, :contains_nuts, :nut_free
    PackageableItem.find_each do |pa|
      pa.update_attributes(nut_free: !pa.nut_free)
    end
  end
end
