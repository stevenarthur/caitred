class ConvertLeadTimeDaysToHours < ActiveRecord::Migration
  def up
    #FoodPartner.find_each do |fa|
      #fa.update_attributes(lead_time_days: (fa.lead_time_days * 24)) if fa.lead_time_days.present?
    #end
    rename_column :food_artisans, :lead_time_days, :lead_time_hours
  end
  def down
    #FoodPartner.find_each do |fa|
      #fa.update_attributes(lead_time_hours: (fa.lead_time_hours/ 24)) if fa.lead_time_hours.present?
    #end
    rename_column :food_artisans, :lead_time_hours, :lead_time_days
  end
end
