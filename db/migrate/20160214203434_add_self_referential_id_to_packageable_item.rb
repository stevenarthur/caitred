class AddSelfReferentialIdToPackageableItem < ActiveRecord::Migration
  def change
    add_column :packageable_items, :parent_id, :string
  end
end
