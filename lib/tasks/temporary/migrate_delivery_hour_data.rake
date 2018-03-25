namespace :delivery_hours do
  desc "Update delivery_hours to use new seconds data"
  task migrate: :environment do
    puts "Migrating delivery hour data"
    delivery_hours = DeliveryHour.all

    ActiveRecord::Base.transaction do

      FoodPartner.find_each do |food_partner|
        begin
          days = JSON.parse(food_partner.delivery_days)
        rescue JSON::ParserError
          days = food_partner.delivery_days.split(",")
        end
        delivery_hour = food_partner.delivery_hours.last
        if delivery_hour.present?
          days.each do |day|
            DeliveryHour.find_or_create_by(
              food_partner_id: food_partner.id,
              day: DeliveryHour.days[day],
              start_time: delivery_hour.hour_start.seconds_since_midnight,
              end_time: delivery_hour.hour_end.seconds_since_midnight
            )
            print "."
          end
        end
      end

      DeliveryHour.where(day: nil).destroy_all
    end

    puts " All done now!"
  end
end
