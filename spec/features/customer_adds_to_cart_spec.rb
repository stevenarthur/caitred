require 'rails_helper'
feature "Customer adds to cart" do

  let(:food_partner){ FoodPartner.create(company_name: "Pips Fish & Chips", url_slug: 'pips-fish', 
                                         priority_order: 1, active: true, delivery_cost: 5.00, minimum_spend: 10.00) }
  let(:delivery_area){ DeliveryArea.create(title: "Sydney") }
  let(:delivery_hour){ DeliveryHour.create(hour_start: "00:00:00", hour_end: "23:00:00"  )}
  let(:menu_category){ MenuCategory.create(name: "Packages", food_partner_id: food_partner.id) }
  let(:postcode){ Postcode.create!(country: "AU", state: "NSW", title: "Sydney", 
                                   zipcode: "2000", delivery_area_id: delivery_area.id ) }
  let(:menu_item_1){ PackageableItem.create!(title: 'Fish', cost: 2.50, active: true, 
                                             menu_category_id: menu_category.id,
                                             food_partner_id: food_partner.id, event_type: ["Lunch"]) }
  let(:menu_item_2){ PackageableItem.create!(title: 'Chips', cost: 1.00, active: true,
                                             menu_category_id: menu_category.id,
                                             food_partner_id: food_partner.id, event_type: ["Lunch"]) }

  before :each do
    food_partner.delivery_areas << delivery_area
    food_partner.delivery_hours << delivery_hour
    food_partner.save
    postcode
    menu_item_1
    menu_item_2
  end

  # There is a delay on these screenshots - so sometimes the amounts haven't updated the time it runs
  it "adds multiple entries to line item", js: true do
    visit partner_from_web_path(food_partner.url_slug)
    save_screenshot('tmp/order-page.png', full: true) 
    within "#qa--package-#{menu_item_1.id}" do
      select "5", from: "enquiry_item[quantity]"
      click_button "Add"
      save_screenshot('tmp/order-page-first_add.png', full: true) 
    end
    within "#qa--package-#{menu_item_2.id}" do
      select "5", from: "enquiry_item[quantity]"
      click_button "Add"
      save_screenshot('tmp/order-page-second_add.png', full: true) 
    end
    within "#qa--package-#{menu_item_2.id}" do
      select "5", from: "enquiry_item[quantity]"
      click_button "Add"
      save_screenshot('tmp/order-page-third_add.png', full: true) 
    end
    within "#qa--package-#{menu_item_1.id}" do
      select "5", from: "enquiry_item[quantity]"
      click_button "Add"
      save_screenshot('tmp/order-page-third_add.png', full: true) 
    end
    expect(page.find("#qa--cart-subtotal").text).to eq "$35.00"
    save_screenshot('tmp/order-finished.png', full: true) 
  end


end
