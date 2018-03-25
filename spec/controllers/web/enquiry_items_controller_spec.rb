require 'rails_helper'

describe Web::EnquiryItemsController do
  render_views

  # Hooray for complex setup :)
  let(:food_partner){ FoodPartner.create(company_name: "Pips Fish & Chips", url_slug: 'pips-fish', 
                                         priority_order: 1, active: true, delivery_cost: 5.00, 
                                         lead_time_hours: 24, minimum_spend: 10.00) }
  let(:delivery_area){ DeliveryArea.create(title: "Sydney") }
  let(:delivery_hour){ DeliveryHour.create(hour_start: "00:00:00", hour_end: "23:00:00"  )}

  let(:package){ PackageableItem.create!(title: 'Lamb Rogan Josh Curry', cost: 2.50, active: true,
                                         minimum_order: 10, food_partner_id: food_partner.id, 
                                         event_type: ["Lunch"]) }
  let(:vegetarian_option){ PackageableItem.create!(title: 'Vegetarian Rogan Josh', cost: 2.00, active: true, 
                                                   parent_id: package.id, food_partner_id: food_partner.id, 
                                                   event_type: ["Lunch"]) }
  let(:gluten_free_option){ PackageableItem.create!(title: 'Gluten Free Rogan Josh', cost: 3.00, active: true, 
                                                   parent_id: package.id, food_partner_id: food_partner.id, 
                                                   event_type: ["Lunch"]) }

  before :each do
    food_partner.delivery_areas << delivery_area
    food_partner.delivery_hours << delivery_hour
    food_partner.save
    package
    vegetarian_option
    gluten_free_option
  end

  # Add a package to the cart. This adds multple items to the cart based on the items variants.
  # Importantly, it should also check to see if the minimum_order_quantity has been set.
  describe "#add_package" do

    before(:each){ session.delete(:enquiry_id) if session[:enquiry_id].present? }
    let(:make_request){ post :add_package, package_items: package_params, format: :js }

    context "adding item and variants to cart" do
      let(:package_params) do
        { 
          "standard_item" => { "quantity" => "8", "packageable_item_id" => package.id },
          "variants" => [ { "quantity" => "1", "packageable_item_id" => vegetarian_option.id },
                          { "quantity" => "2", "packageable_item_id" => gluten_free_option.id } ],
          "additional_instructions": "I would like some gum" 
        }
      end
      it "adds items to cart" do
        make_request
        expect(session[:enquiry_id]).to_not eq nil
        enquiry = Enquiry.find(session[:enquiry_id])
        expect(response).to be_a_success
        expect(enquiry.enquiry_items.size).to eq 3
        expect(enquiry.subtotal).to eq 28.0
      end
    end
    
    # Test that 0 works on the variants rejector 
    context "adding item with no variants to cart" do
      let(:package_params) do
        { 
          "standard_item" => { "quantity" => "11", "packageable_item_id" => package.id },
          "variants" => [ { "quantity" => "0", "packageable_item_id" => vegetarian_option.id },
                          { "quantity" => "0", "packageable_item_id" => gluten_free_option.id } ],
          "additional_instructions": "I would like some gum" 
        }
      end
      it "adds item to cart" do
        make_request
        expect(response).to be_a_success
        expect(session[:enquiry_id]).to_not eq nil
        enquiry = Enquiry.find(session[:enquiry_id])
        expect(enquiry.enquiry_items.size).to eq 1
        expect(enquiry.subtotal).to eq 27.50
      end
    end

    # Test ordering only the variants without any standard. 
    context "adding item with no variants to cart" do
      let(:package_params) do
        { 
          "standard_item" => { "quantity" => "0", "packageable_item_id" => package.id },
          "variants" => [ { "quantity" => "10", "packageable_item_id" => vegetarian_option.id },
                          { "quantity" => "0", "packageable_item_id" => gluten_free_option.id } ],
          "additional_instructions": "I would like some gum" 
        }
      end
      it "adds item to cart" do
        make_request
        expect(response).to be_a_success
        expect(session[:enquiry_id]).to_not eq nil
        enquiry = Enquiry.find(session[:enquiry_id])
        expect(enquiry.enquiry_items.size).to eq 1
        expect(enquiry.subtotal).to eq 20.00
      end
    end

    context "invalid quantities" do
      let(:package_params) do
        { 
          "standard_item" => { "quantity" => "7", "packageable_item_id" => package.id },
          "variants" => [ { "quantity" => "2", "packageable_item_id" => vegetarian_option.id },
                          { "quantity" => "0", "packageable_item_id" => gluten_free_option.id } ]
        }
      end
      it "with invalid quantities, returns error" do
        make_request
        expect(response).to be_a_success
        expect(session[:enquiry_id]).to eq nil
      end
    end

    context "with another item from another vendor" do
      pending "clears the other vendors items"
    end

    # Update package in the cart. 
    # This effectively removes items already in the cart and re-adds for simplicity and hits the
    # same context
    context "#updating_a_package" do 

      let(:package_params) do
        { 
          "standard_item" => { "quantity" => "8", "packageable_item_id" => package.id },
          "variants" => [ { "quantity" => "1", "packageable_item_id" => vegetarian_option.id },
                          { "quantity" => "2", "packageable_item_id" => gluten_free_option.id } ],
          "additional_instructions": "I would like some gum" 
        }
      end
      let(:updated_package_params) do
        { 
          "standard_item" => { "quantity" => "0", "packageable_item_id" => package.id },
          "variants" => [ { "quantity" => "15", "packageable_item_id" => vegetarian_option.id },
                          { "quantity" => "8", "packageable_item_id" => gluten_free_option.id } ],
          "additional_instructions": "Updated Additional Instructions" 
        }
      end
      before :each do
        make_request
        expect(session[:enquiry_id]).to_not eq nil
      end

      it "adds items to cart" do
        # First check it worked
        enquiry = Enquiry.find(session[:enquiry_id])
        expect(response).to be_a_success
        expect(enquiry.enquiry_items.size).to eq 3
        expect(enquiry.subtotal).to eq 28.0

        # Secondary (Actual Check)
        post :add_package, package_items: updated_package_params, format: :js
        expect(session[:enquiry_id]).to eq enquiry.id
        enquiry.reload
        expect(response).to be_a_success
        expect(enquiry.enquiry_items.size).to eq 2
        expect(enquiry.subtotal).to eq 54.0
      end

    end
  end

end
