class AddDayToDeliveryHour < ActiveRecord::Migration
  def change
    add_column :delivery_hours, :day, :integer, index: true
  end
end
