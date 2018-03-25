class AddSeoPropertiesToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :meta_title, :string
    add_column :menus, :meta_description, :string
  end
end
