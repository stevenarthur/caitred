require 'rails_helper'

# Full workflow for a customer ordering from fresh.
# This is also a non-magic container for everything going on here. 
#
# 1. Customer puts in their postcode.
# 2. Customer selects a partner
# 3. Customer adds item to card
# 4. Customer gets to checkout
# 5. Customer orders
# 6. Invoice is created

# Problem is stripe token not creating.
feature "Customer Order" do
  let(:two_days_from_now){ (Date.today + 2.days).strftime("%d %b %Y") }
  let(:food_partner){ FoodPartner.create(company_name: "Pips Fish & Chips", url_slug: 'pips-fish', 
                                        priority_order: 1, active: true, delivery_cost: 5.00, minimum_spend: 10.00) }
  let(:delivery_hour) do
    integer_day = DeliveryHour.days[(Date.today + 2.days).strftime("%A").downcase]
    DeliveryHour.create(day: integer_day, start_time: 32400, end_time: 61200)
  end

  let(:postcode){ Postcode.create!(country: "AU", state: "NSW", title: "Sydney", zipcode: "2000") }
  let(:menu_category){ MenuCategory.create!(name: 'CategoryItems', 
                                            sort_order: 1, food_partner_id: food_partner.id) }
  let(:menu_item_1){ PackageableItem.create!(title: 'Fish', cost: 2.50, active: true,
                                             menu_category_id: menu_category.id,
                                             food_partner_id: food_partner.id, event_type: ["Lunch"]) }
  let(:menu_item_2){ PackageableItem.create!(title: 'Chips', cost: 1.00, active: true,
                                             menu_category_id: menu_category.id,
                                             food_partner_id: food_partner.id, event_type: ["Lunch"]) }

  before :each do
    food_partner.postcodes << postcode
    food_partner.delivery_hours << delivery_hour
    food_partner.save
    postcode
    menu_item_1
    menu_item_2
  end

  context "new customer" do

    it "customer orders", js: true do
      search_for_2000

      # Food Partner Page
      save_screenshot('tmp/search-results.png') # For some reason this only works with the screenshot
      page.find("#qa--partner-#{food_partner.id}").trigger('click')
      #click_link "Pips Fish & Chips", match: :first
      expect(page).to have_content "Lunch"
      expect(page).to_not have_content "Dinner" # Ensure event types without food dont show
      fill_in 'qa--delivery-day', with: two_days_from_now 
      select "3:00 PM", from: "qa--enquiry-time"
      add_fish_to_cart
      expect(page).to_not have_content "Your cart is empty!"
      add_chips_to_cart
    end
  end

private
  def search_for_2000
    visit root_path
    fill_in :postcode, with: '2000'
    click_button "View Catering Options"
    expect(page).to have_content "PIPS FISH & CHIPS"
  end

  def add_fish_to_cart
    within "#qa--package-#{menu_item_1.id}" do
      select "5", from: "enquiry_item[quantity]"
      click_button "Add"
    end
    save_screenshot('tmp/added-fish.png') # For some reason this only works with the screenshot
    expect(page.find("#qa--cart-subtotal").text).to eq "$12.50"
    expect(page.find("#qa--delivery-fee").text).to eq "$5.00"
    expect(page.find("#qa--payment-fee").text).to eq "$0.81" # 0.30 + (17.50 * 0.029)
    expect(page.find("#qa--cart-total").text).to eq "$18.31"
  end

  def add_chips_to_cart
    within "#qa--package-#{menu_item_2.id}" do
      select "10", from: "enquiry_item[quantity]"
      click_button "Add"
    end
    save_screenshot('tmp/added-chips.png') # For some reason this only works with the screenshot
    expect(page.find("#qa--cart-subtotal").text).to eq "$22.50"
    expect(page.find("#qa--delivery-fee").text).to eq "$5.00"
    expect(page.find("#qa--payment-fee").text).to eq "$1.10" # 0.30 + (27.50 * 0.029)
    expect(page.find("#qa--cart-total").text).to eq "$28.60"
  end

end
