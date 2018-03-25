class AddProperStartAndEndToDeliveryHours < ActiveRecord::Migration
  def change
    add_column :delivery_hours, :start_time, :integer, index: true
    add_column :delivery_hours, :end_time, :integer, index: true
  end
end
