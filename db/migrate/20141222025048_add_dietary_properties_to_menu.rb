class AddDietaryPropertiesToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :dietary_properties, :string, array: true, default: '{}'
  end
end
