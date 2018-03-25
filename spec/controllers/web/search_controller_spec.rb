require 'rails_helper' 

describe Web::SearchController do
  let(:monday_delivery_hour){ DeliveryHour.create!( food_partner_id: sydney_city_food_partner.id, day: 1, 
                              start_time: 32400, end_time: 61200) }
  let(:tuesday_delivery_hour){ DeliveryHour.create!( food_partner_id: sydney_city_food_partner.id, day: 2, 
                              start_time: 32400, end_time: 61200) }
  let(:tuesday_delivery_hour_two){ DeliveryHour.create!( food_partner_id: zetland_food_partner.id, day: 2, 
                              start_time: 32400, end_time: 61200) }
  let(:wednesday_delivery_hour){ DeliveryHour.create!( food_partner_id: zetland_food_partner.id, day: 3, 
                              start_time: 32400, end_time: 61200) }
  let(:sydney_city_food_partner){ FoodPartner.create!( company_name: 'Sydney Partner', lead_time_hours: 24, active: true ) } 
  let(:zetland_food_partner){ FoodPartner.create!( company_name: 'Zetland Partner', lead_time_hours: 24, active: true) } 
  let(:sydney_postcode){ Postcode.create!( zipcode: '2000', title: 'Sydney City') }
  let(:waterloo_postcode){ Postcode.create!( zipcode: '2017', title: 'Waterloo') }
  let(:zetland_postcode){ Postcode.create!( zipcode: '2017', title: 'Zetland') }

  # get '/in/(:locality) (also known as partner_search_path)
  describe "#show" do
    let(:postcode_params){ { postcode: '2000' } }
    let(:locality_params){ { locality: 'zetland' } }

    before :each do
      waterloo_postcode; zetland_postcode; sydney_postcode;
      zetland_food_partner.postcodes << [zetland_postcode, sydney_postcode]
      zetland_food_partner.save;
    end

    context "when supplied a locality" do
      it "redirects to the locality" do
        get :show, { locality: 'zetland' }
        expect(assigns(:postcode)).to eq zetland_postcode
        expect(assigns(:food_partners)).to eq [zetland_food_partner]
        expect(response.status).to eq 200
      end
    end

    context "when supplied a postcode" do
      it "redirects to the first locality in the postcode" do
        get :show, { postcode: '2017' } 
        expect(assigns(:postcode)).to eq waterloo_postcode
        expect(assigns(:food_partners)).to eq [zetland_food_partner]
        expect(response.status).to eq 200
      end
    end

    context "when supplied nothing" do
      it "redirects to sydney" do
        get :show, {} 
        expect(assigns(:postcode)).to eq sydney_postcode
        expect(assigns(:food_partners)).to eq [zetland_food_partner]
        expect(response.status).to eq 200
      end
    end
  end

  # post '/in/(:locality)/search' (also known as partner_advanced_search_path) used for the advanced search.
  # The first 3 tests are pretty much redundant tests from the model methods but they're important so 
  # I want to double up here.
  describe '#search' do
    before :each do
      waterloo_postcode; zetland_postcode; sydney_postcode;
      monday_delivery_hour; tuesday_delivery_hour; tuesday_delivery_hour_two; wednesday_delivery_hour;
      zetland_food_partner.postcodes << [zetland_postcode, sydney_postcode, waterloo_postcode]
      zetland_food_partner.save;
    end

    context "when only date is supplied" do
      it "returns food partners" do
        post :search, { date: "12th Jul 2016", direction: "ASC", locality: "sydney-city" }
        expect(assigns(:food_partners)).to eq [sydney_city_food_partner, zetland_food_partner]
      end
    end

    context "when only a time is supplied" do
      it "returns food partners" do
        post :search, { eat_time: "11:00 AM", direction: "ASC", locality: "sydney-city" }
        expect(assigns(:food_partners)).to eq [sydney_city_food_partner, zetland_food_partner]
      end
    end

    # This checks that the order can actually go through.
    context "when both a date and time is supplied" do
      it "returns correctly scoped partners" do
        Timecop.freeze(Time.zone.parse("6th Jul 2016 10:00am")) do
          post :search, { date: "13th Jul 2016", direction: "ASC", 
                          eat_time: "11:00 AM", locality: "sydney-city" }
          expect(assigns(:food_partners)).to eq [zetland_food_partner]
        end
        # Ensure it doesnt show if not in lead_time_hours
        Timecop.freeze(Time.zone.parse("13th Jul 2016 10:00am")) do
          post :search, { date: "13th Jul 2016", direction: "ASC", 
                          eat_time: "11:00 AM", locality: "sydney-city" }
          expect(assigns(:food_partners)).to eq []
        end
      end
    end

  end

  # This is used when the person update their search from the food partner page
  # I think we want to get rid of this.
  describe "#update_enquiry_parameters" do
  end

  # Helper search thing to convert the postcode to the locality. 
  describe "#create" do
  end

end
