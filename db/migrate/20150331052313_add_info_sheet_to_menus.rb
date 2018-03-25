class AddInfoSheetToMenus < ActiveRecord::Migration
  def change
  	add_column :menus, :info_sheet, :string
  end
end
