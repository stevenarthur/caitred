class AddXeroIdToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :xero_item_id, :string
  end
end
