require 'rails_helper'

# Delivery Hours Exist for Food Partners as 'opening windows'
describe DeliveryHour do

  context "validations" do
    let(:food_partner_two){ create(:food_partner) } 
    let(:food_partner){ create(:food_partner) } 
    let(:valid_delivery_hour) do 
      DeliveryHour.new(food_partner_id: food_partner.id, day: 1, start_time: 2000, end_time: 3000)
    end

    it "requires a food partner" do
      expect(valid_delivery_hour).to be_valid
      valid_delivery_hour.food_partner_id = nil
      expect(valid_delivery_hour).to_not be_valid
    end

    it "requires a day" do
      expect(valid_delivery_hour).to be_valid
      valid_delivery_hour.day = nil
      expect(valid_delivery_hour).to_not be_valid
    end

    it "can't have overlapping times per day for the same food partner" do
      valid_delivery_hour.save!
      expect( 
        DeliveryHour.new(food_partner_id: food_partner_two.id, day: 1, start_time: 2000, end_time: 3000)
      ).to be_valid
      expect( 
        DeliveryHour.create(food_partner_id: food_partner.id, day: 1, start_time: 2100, end_time: 3000)
      ).to_not be_valid
    end
  end

  context "selectable_times" do
    let(:valid_delivery_hour) do 
      DeliveryHour.new(food_partner_id: 1, day: 1, start_time: 00, end_time: 7200)
    end

    it "returns 15 minute increments" do
      expect( valid_delivery_hour.formattable_times ).to eq ["12:00 AM", "12:15 AM", "12:30 AM", "12:45 AM", 
                                                            "1:00 AM", "1:15 AM", "1:30 AM", "1:45 AM", 
                                                            "2:00 AM"]
    end
  end

end
