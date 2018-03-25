class ChangeParkingInformationLength < ActiveRecord::Migration
  def change
    change_column :addresses, :parking_information, :text
  end
end
