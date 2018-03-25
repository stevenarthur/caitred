class AddMenuCategoryReferenceToPackagableItems < ActiveRecord::Migration
  def change
    add_reference :packageable_items, :menu_category
  end
end
