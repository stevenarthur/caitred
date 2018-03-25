class ChangeAddressColumnType < ActiveRecord::Migration
  def up
    change_column :addresses, :parking_information, :text
  end
  def up
    change_column :addresses, :parking_information, :string
  end
end
