namespace :caitre_d do
  desc "Migration away from delivery areas to a straightforward postcode relationship"

  task migrate_delivery_areas_to_postcodes: :environment do

    FoodPartner.find_each do |partner|
      partner.delivery_areas.each do |delivery_area|
        delivery_area.postcodes.each do |postcode|
          FoodPartnerDeliveryPostcode.create!(postcode_id: postcode.id,
                                              food_partner_id: partner.id)
        end
      end
    end

  end

end
