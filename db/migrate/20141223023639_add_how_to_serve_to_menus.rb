class AddHowToServeToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :how_to_serve, :string
  end
end
