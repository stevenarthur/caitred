# encoding: UTF-8

require 'rails_helper'

describe FoodPartner do

  it_behaves_like 'generates a url slug'

  context "delivery_postcodes" do
    let(:food_partner){ create(:food_partner) }
    let(:postcode){ Postcode.create!( zipcode: '2000', title: 'Sydney City' ) }

    it "has no postcodes by default" do
      expect(FoodPartner.new.postcodes).to eq []
    end

    it "can assign postcodes" do
      expect {
        food_partner.postcodes << postcode
        food_partner.save
      }.to change(FoodPartnerDeliveryPostcode, :count).by 1
      expect(postcode.food_partners).to eq [food_partner]
      expect(food_partner.postcodes).to eq [postcode]
    end
  end

  context "search scopes" do
    # Equivalent to a 9AM - 5PM
    let(:monday_delivery_hour){ DeliveryHour.create!( food_partner_id: sydney_city_food_partner.id, day: 1, 
                                start_time: 32400, end_time: 61200) }
    let(:tuesday_delivery_hour){ DeliveryHour.create!( food_partner_id: sydney_city_food_partner.id, day: 2, 
                                start_time: 32400, end_time: 61200) }

    let(:sydney_city_food_partner){ FoodPartner.create!( company_name: 'Sydney Partner' ) } 
    let(:zetland_food_partner){ FoodPartner.create!( company_name: 'Zetland Partner') } 
    let(:sydney_postcode){ Postcode.create!( zipcode: '2000', title: 'Sydney City') }
    let(:zetland_postcode){ Postcode.create!( zipcode: '2017', title: 'Zetland') }

    # Returns partners in the postcode. Importantly this is tied throguh delivery_areas so it actually
    # returns anyone else in the delivery area.
    context "#in_postcode(postcode)" do
      before :each do
        sydney_postcode; zetland_postcode
        sydney_city_food_partner.postcodes << [sydney_postcode, zetland_postcode]
        zetland_food_partner.postcodes << [sydney_postcode, zetland_postcode]
      end

      it "returns partners in delivery area of postcode" do
        expect(FoodPartner.in_postcode('2000').to_a).to include(zetland_food_partner)
        expect(FoodPartner.in_postcode('2000').to_a).to include(sydney_city_food_partner)
      end
    end

    # Returns partners that are available to deliver at a given date and time. This should be the main
    # search query.
    context "#open_on_and_delivers_at(datetime)" do
      before :each do
        zetland_food_partner
        monday_delivery_hour
        sydney_city_food_partner.reload
      end

      it "returns partners that are open" do
        datetime = Time.zone.parse("18th July 2016 4:00 PM")
        expect(FoodPartner.open_on_and_delivers_at(datetime)).to eq [sydney_city_food_partner]
        datetime = Time.zone.parse("18th July 2016 4:59 PM")
        expect(FoodPartner.open_on_and_delivers_at(datetime)).to eq [sydney_city_food_partner]
        datetime = Time.zone.parse("18th July 2016 5:01 PM")
        expect(FoodPartner.open_on_and_delivers_at(datetime)).to eq []
        datetime = Time.zone.parse("19th July 2016 4:00 PM")
        expect(FoodPartner.open_on_and_delivers_at(datetime)).to eq []
      end

      it "returns true and false values" do
        datetime = Time.zone.parse("18th July 2016 4:00 PM")
        expect(sydney_city_food_partner.open_on_and_delivers_at?(datetime)).to eq  true
        datetime = Time.zone.parse("18th July 2016 4:59 PM")
        expect(sydney_city_food_partner.open_on_and_delivers_at?(datetime)).to eq true
        datetime = Time.zone.parse("18th July 2016 5:01 PM")
        expect(sydney_city_food_partner.open_on_and_delivers_at?(datetime)).to eq false
        datetime = Time.zone.parse("19th July 2016 4:00 PM")
        expect(sydney_city_food_partner.open_on_and_delivers_at?(datetime)).to eq false
      end
    end

    # Returns partners that are open on a given day. Is a straightforward boolean toggle and should only
    # really be used when a time hasn't been given.
    context "#open_on(date)" do

      let(:a_monday){ Date.parse("18th July 2016") } 
      let(:a_tuesday){ Date.parse("19th July 2016") } 
      let(:a_monday_datetime){ DateTime.parse("18th July 2016") } 
      let(:a_tuesday_datetime){ DateTime.parse("19th July 2016") } 

      before :each do
        zetland_food_partner
        monday_delivery_hour
        sydney_city_food_partner.reload
      end

      it "returns a list of open vendors" do
        expect(FoodPartner.open_on(a_monday)).to eq [sydney_city_food_partner]
        expect(FoodPartner.open_on(a_monday_datetime)).to eq [sydney_city_food_partner]
        expect(FoodPartner.open_on(a_tuesday)).to eq []
      end

      it "returns true or false if open or not" do
        expect(a_monday.strftime("%A")).to eq "Monday"
        expect(sydney_city_food_partner.open_on?(a_monday)).to eq true
        expect(sydney_city_food_partner.open_on?(a_monday_datetime)).to eq true

        expect(a_tuesday.strftime("%A")).to eq "Tuesday"
        expect(sydney_city_food_partner.open_on?(a_tuesday)).to eq false
        expect(sydney_city_food_partner.open_on?(a_tuesday_datetime)).to eq false
      end
    end

    # Returns partners that are open at a given time. Again, straightforward boolean toggle and only really
    # relevant or should be used when a date isn't supplied..
    context "#deliver_at(time)" do

      before :each do
        monday_delivery_hour
        sydney_city_food_partner.reload
        zetland_food_partner
      end

      it "returns partners that deliver at 4pm" do
        expect(FoodPartner.deliver_at("7am")).to eq []
        expect(FoodPartner.deliver_at("4pm")).to eq [sydney_city_food_partner]
      end

      it "returns true of false if delivers_at?(time)" do
        expect(sydney_city_food_partner.delivers_at?("8.59am")).to eq false
        expect(sydney_city_food_partner.delivers_at?("8:59am")).to eq false
        expect(sydney_city_food_partner.delivers_at?("4pm")).to eq true
        expect(sydney_city_food_partner.delivers_at?("5:01pm")).to eq false
        expect(sydney_city_food_partner.delivers_at?("5.01pm")).to eq false
      end

    end

    # Returns partners that cater for a specific event type
    context "#by_event_type(event_type)" do
      before(:each) do
        sydney_city_food_partner.update_attribute("event_type", ['Lunch', 'Breakfast'])
        sydney_city_food_partner.reload
      end

      it "only returns those that offer with breakfast" do
        expect(FoodPartner.by_event_type("Dinner")).to eq []
        expect(FoodPartner.by_event_type(["Dinner"])).to eq []
        expect(FoodPartner.by_event_type("Breakfast")).to eq [sydney_city_food_partner]
        expect(FoodPartner.by_event_type(['Breakfast'])).to eq [sydney_city_food_partner]
      end

    end

    # Returns partners that are both active and the lead time is within the limits of the current time.
    # Similar to open_on_and_delivers_at however is inclusive of lead_time.
    context "#available_to_purchase_at(datetime)" do

      before :each do
        tuesday_delivery_hour
        sydney_city_food_partner.lead_time_hours = 24
        sydney_city_food_partner.active = true
        sydney_city_food_partner.save; sydney_city_food_partner.reload
        zetland_food_partner
      end

      it "not available 1 minute before lead time" do
        less_than_24_hours_away = Time.zone.parse("19th July 2016 9:59am") 
        Timecop.freeze(Time.zone.parse("18th July 2016 10:00am")) do
          expect(FoodPartner.available_to_purchase_at(less_than_24_hours_away)).to eq []
        end
      end

      it "available 1 second after lead time" do
        more_than_24_hours_away = Time.zone.parse("19th July 2016 10:01am") 
        Timecop.freeze(Time.zone.parse("18th July 2016 10:00am")) do
          expect(FoodPartner.available_to_purchase_at(more_than_24_hours_away)).to eq [sydney_city_food_partner]
        end
      end

      it "not available if partner inactive" do
        sydney_city_food_partner.update_attribute('active', false); sydney_city_food_partner.reload;
        more_than_24_hours_away = Time.zone.parse("19th July 2016 10:01am") 
        Timecop.freeze(Time.zone.parse("18th July 2016 10:00am")) do
          expect(FoodPartner.available_to_purchase_at(more_than_24_hours_away)).to eq []
        end
      end

      context "#available_to_purchase_at?(datetime)" do
        it "falsee 1 minute before lead time" do
          less_than_24_hours_away = Time.zone.parse("19th July 2016 9:59am") 
          Timecop.freeze(Time.zone.parse("18th July 2016 10:00am")) do
            expect(
              sydney_city_food_partner.available_to_purchase_at?(less_than_24_hours_away)
            ).to eq false
          end
        end

        it "true 1 second after lead time" do
          more_than_24_hours_away = Time.zone.parse("19th July 2016 10:01am") 
          Timecop.freeze(Time.zone.parse("18th July 2016 10:00am")) do
            expect(
              sydney_city_food_partner.available_to_purchase_at?(more_than_24_hours_away)
            ).to eq true
          end
        end

        it "false if partner inactive" do
          sydney_city_food_partner.update_attribute('active', false); sydney_city_food_partner.reload;
          more_than_24_hours_away = Time.zone.parse("19th July 2016 10:01am") 
          Timecop.freeze(Time.zone.parse("18th July 2016 10:00am")) do
            expect(
              sydney_city_food_partner.available_to_purchase_at?(more_than_24_hours_away)
            ).to eq false
          end
        end


      end
    end
  end

  it 'generates a url slug when first created' do
    food_partner = FoodPartner.create(
      company_name: 'my company',
      minimum_spend: 0,
      minimum_attendees: 0,
      maximum_attendees: 0,
      delivery_cost: 0
    )
    food_partner.reload
    expect(food_partner.url_slug).to eq 'my-company'
  end

  describe '#email?' do
    let(:food_partner) { create(:food_partner, email: email) }

    context 'blank' do
      let(:email) { '' }
      it 'returns false' do
        expect(food_partner.email?).to be false
      end

    end

    context 'nil' do
      let(:email) { nil }
      it 'returns false' do
        expect(food_partner.email?).to be false
      end

    end

    context 'present' do
      let(:email) { 'test' }
      it 'returns true' do
        expect(food_partner.email?).to be true
      end
    end
  end

  describe '#phone' do
    let(:food_partner) { create(:food_partner, phone_number: phone_number) }

    context 'blank' do
      let(:phone_number) { '' }
      it 'returns false' do
        expect(food_partner.phone?).to be false
      end

    end

    context 'nil' do
      let(:phone_number) { nil }
      it 'returns false' do
        expect(food_partner.phone?).to be false
      end

    end

    context 'present' do
      let(:phone_number) { 'test' }
      it 'returns true' do
        expect(food_partner.phone?).to be true
      end
    end
  end

  describe '#for_attendees' do
    let(:food_partner_1) do
      create(:food_partner,
             minimum_attendees: 10,
             maximum_attendees: 20)
    end
    let(:food_partner_2) do
      create(:food_partner,
             minimum_attendees: 5,
             maximum_attendees: 15)
    end

    it 'does not food partners with higher min attendees' do
      results = FoodPartner.for_attendees(8)
      expect(results).to include food_partner_2
      expect(results).not_to include food_partner_1
    end

    it 'does not return food partners with lower max attendees' do
      results = FoodPartner.for_attendees(18)
      expect(results).to include food_partner_1
      expect(results).not_to include food_partner_2
    end
  end

end
