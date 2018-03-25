class AddEventDateAndTimeDirectlyOnEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :event_time, :time
    add_column :enquiries, :event_date, :date
  end
end
