class AddHalalAndNutFreeToPackagableItems < ActiveRecord::Migration
  def change
    add_column :packageable_items, :halal, :boolean, default: false
    add_column :packageable_items, :nut_free, :boolean, default: false
  end
end
