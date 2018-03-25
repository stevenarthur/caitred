require 'rails_helper'

feature 'Customer Checkout' do
  let(:two_days_from_now){ (Date.today + 2.days).strftime("%d %b %Y") }
  let(:food_partner){ FoodPartner.create(company_name: "Pips Fish & Chips", url_slug: 'pips-fish', 
                                         priority_order: 1, active: true, delivery_cost: 5.00, 
                                         lead_time_hours: 24, minimum_spend: 10.00) }
    
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
  let(:enquiry){ Enquiry.create!() }

  before :each, js: true do
    food_partner.postcodes << postcode
    food_partner.delivery_hours << delivery_hour
    food_partner.save
    postcode
    menu_item_1
    menu_item_2
    visit partner_from_web_path(food_partner.url_slug)
    set_event_details
    add_fish_to_cart
    page.find('#qa--order').click()
  end

  it "completes checkout", js: true do
    # Checkout Page
    expect(page).to have_content "Are you the person our Food Partner"
    save_screenshot('tmp/checkout.png', full: true)

    # Event Details
    expect(page).to have_field("enquiry_event_date", with: two_days_from_now)
    expect(page).to have_field("enquiry_event_time", with: "5:00 PM")
    fill_in "enquiry_number_of_attendees", with: 10
    fill_in "enquiry_additional_messages", with: "Please arrive promptly"

    # Delivery Details
    fill_in 'enquiry_address_company', with: "Facebook"
    fill_in 'enquiry_address_line_1', with: "100 George Street"
    fill_in 'enquiry_address_suburb', with: "Sydney"
    fill_in 'enquiry_address_parking_information', with: "It is a nightmare to enter this building. Speak to paddy."

    # Personal Details
    fill_in 'enquiry_customer_first_name', with: "Mark"
    fill_in 'enquiry_customer_last_name', with: "Zuckerberg"
    fill_in 'enquiry_customer_email', with: 'mark@example.com'
    fill_in 'enquiry_customer_telephone', with: '0412 345 678'

    # Additional Contact
    expect(page).to_not have_content "Please provide details of the person who will be available"
    page.find('#qa--additional-contact').click()
    expect(page).to have_content "Please provide details of the person who will be available"

    fill_in 'enquiry_customer_additional_first_name', with: "Cheryl"
    fill_in 'enquiry_customer_additional_last_name', with: "Sandberg"
    fill_in 'enquiry_customer_additional_email', with: 'cheryl@example.com'
    fill_in 'enquiry_customer_additional_telephone', with: '0412 345 678'

    click_button "Continue"
    expect(page).to have_content "SUMMARY OF YOUR ORDER"
    save_screenshot('tmp/payment-page.png', full: true) 


    ## Credit Card Details
    #expect(page).to have_content "3. PAYMENT"
    #fill_in 'card_number', with: '4242424242424242'
    #select 'January', from: 'card_month'
    #select (Date.today.year + 1), from: 'card_year'
    #fill_in 'card_code', with: '123'
    #save_screenshot('tmp/populated-order-page.png', full: true)
    #page.find('#js--order-button').click()

    #expect(page).to have_content "We have received your order."
    #save_screenshot('tmp/thanks-page.png', full: true) # For some reason this only works with the screenshot
  end

  pending "when customer contact is reversed"

private
  def set_event_details
    fill_in "enquiry_postcode", with: "2000"
    fill_in 'qa--delivery-day', with: two_days_from_now 
    select "5:00 PM", from: "qa--enquiry-time"
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


end
