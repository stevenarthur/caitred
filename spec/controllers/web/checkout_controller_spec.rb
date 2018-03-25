require 'rails_helper'
describe Web::CheckoutController, type: :controller do

  let(:food_partner){ FoodPartner.create(company_name: "Pips Fish & Chips", url_slug: 'pips-fish', lead_time_hours: 24, 
                                        priority_order: 1, active: true, delivery_cost: 5.00, minimum_spend: 10.00) }
  let(:delivery_hour){ DeliveryHour.create(hour_start: "00:00:00", hour_end: "23:00:00"  )}
  let(:postcode){ Postcode.create!(country: "AU", state: "NSW", title: "Sydney", zipcode: "2000" ) }
  let(:menu_category){ MenuCategory.create!(name: 'CategoryItems', 
                                            sort_order: 1, food_partner_id: food_partner.id) }
  let(:menu_item_1){ PackageableItem.create!(title: 'Fish', cost: 2.50, active: true,
                                             menu_category_id: menu_category.id,
                                             food_partner_id: food_partner.id, event_type: ["Lunch"]) }
  let(:menu_item_2){ PackageableItem.create!(title: 'Chips', cost: 1.00, active: true,
                                             menu_category_id: menu_category.id,
                                             food_partner_id: food_partner.id, event_type: ["Lunch"]) }

  let(:enquiry) do
    enquiry = Enquiry.create( food_partner_id: food_partner.id )
    enquiry.enquiry_items.new( quantity: 5, packageable_item_id: menu_item_1.id )
    enquiry.populate_from_enquiry_items
    enquiry.save
    enquiry
  end 

  before :each do
    food_partner.postcodes << postcode
    food_partner.delivery_hours << delivery_hour
    food_partner.save
    postcode
    menu_item_1
    menu_item_2

    # Setup current enquiry
    session[:enquiry_id] = enquiry.id
  end

  describe "#new" do
    let(:valid_params){ { "postcode": "2000", event_date: "30 Apr 2017", event_time: "7:00 AM" } }

    context "valid" do
      it "renders the checkout page" do
        post :new, slug: food_partner.url_slug, enquiry: valid_params
        expect(response.status).to eq 200
      end
    end

    context "invalid" do
      # Importantly, the key is always going to be there, it might just be ""
      context "redirects to checkout when" do
        it "no postcode passed in" do
          valid_params["postcode"] = ""
          post :new, slug: food_partner.url_slug, enquiry: valid_params
          expect(flash[:error]).to eq "This food partner does not deliver on this date at this time."
          expect(response.status).to eq 302
          expect(response).to redirect_to partner_from_web_url(slug: food_partner.url_slug)
        end
        it "no date passed in" do
          valid_params["event_date"] = ""
          post :new, slug: food_partner.url_slug, enquiry: valid_params
          expect(flash[:error]).to eq "This food partner does not deliver on this date at this time."
          expect(response.status).to eq 302
          expect(response).to redirect_to partner_from_web_url(slug: food_partner.url_slug)
        end
        it "no time passed in" do
          valid_params["event_time"] = ""
          post :new, slug: food_partner.url_slug, enquiry: valid_params
          expect(flash[:error]).to eq "This food partner does not deliver on this date at this time."
          expect(response.status).to eq 302
          expect(response).to redirect_to partner_from_web_url(slug: food_partner.url_slug)
        end
        pending "partner doesn't deliver to postcode" 
        pending "partner doesn't deliver at time"
        pending "partner doesn't deliver on day" 

        describe "Lead Time" do
          let(:event_date){ valid_params[:event_date] } 
          let(:event_time){ valid_params[:event_time] } 
          let(:event_date_and_time){ Time.zone.parse("#{event_date} #{event_time}") }

          it "lead time is less than the partner allows" do
            Timecop.freeze((event_date_and_time - 2.hours)) do
              post :new, slug: food_partner.url_slug, enquiry: valid_params
              expect(flash[:error]).to eq "This food partner does not deliver on this date at this time."
              expect(response.status).to eq 302
              expect(response).to redirect_to partner_from_web_url(slug: food_partner.url_slug)
            end
          end

          it "over the lead time" do
            Timecop.freeze((event_date_and_time - 25.hours)) do
              post :new, slug: food_partner.url_slug, enquiry: valid_params
              expect(flash[:error]).to_not eq "This food partner requires a lead time of 24 hours or more"
              expect(response.status).to eq 200
              expect(response).to render_template "web/checkout/new"
            end
          end
        end

      end
    end

  end

  describe "#create" do
    pending "sets enquiry details from parameters"
    context "is a new customer" do
      context "basic info sent" do
        pending "sends an email to YouChews & Customer"
        pending "puts the correct address in the email" 
        pending "puts the correct content in the email"
        pending "additional info is added"
        pending "dietary items added to supplier email"
      end

      pending "creates a new customer"
      pending "creates a new enquiry"
    end

    context "for existing customer" do
      pending "adds the order to the customer"

      context "with an existing address" do
        context "submitting with a new address" do
          pending "creates a new address for the customer"
          pending "sets that new address for the enquiry"
        end
      end
    end

    context "for logged in customer" do
      pending "adds the order to the customer"
    end

  end

end
