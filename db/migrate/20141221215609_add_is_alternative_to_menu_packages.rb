class AddIsAlternativeToMenuPackages < ActiveRecord::Migration
  def change
    add_column :menu_packages, :is_alternative, :boolean
  end
end
