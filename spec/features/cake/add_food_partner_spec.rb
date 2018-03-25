require "rails_helper"

feature "Cake: Add / Update Food Partner" do

  let(:sydney_postcode){ Postcode.create!(zipcode: 2000, title: "Sydney CBD") }
  let(:admin){ Authentication::AdminUser.create!(first_name: "Paul", last_name: "Millar", 
                                                 username: "paulm", password: 'password', 
                                                 password_confirmation: 'password',
                                                 email_address: 'paul@paulmillar.net', 
                                                 mobile_number: '0425616397', is_power_user: true) } 
  
  before :each do
    admin
    login_to_cake
  end

  it "creates food partner" do
    navigate_to_new_partner_page
    fill_in_food_partner_details

    click_button "Save Food Partner Details"
    expect(page).to have_content "Food Partner Created"

    food_partner = FoodPartner.last
    expect(food_partner.company_name).to eq "Mad Mex"

    # Ensure Delivery Hours are Created
    expect(food_partner.delivery_hours.count).to eq 1
    delivery_hours = food_partner.delivery_hours.first
    expect(delivery_hours.start_time).to eq 32400 
    expect(delivery_hours.end_time).to eq 61200
    expect(delivery_hours.food_partner).to eq food_partner

  end

  it "updates food partner" do
    create_food_partner_through_form

    select("12:00 PM", from: "food_partner[delivery_hours_attributes][0][start_time]")
    select("8:00 PM", from: "food_partner[delivery_hours_attributes][0][end_time]")
    click_button "Save Food Partner Details"

    expect(page).to have_content "Food Partner updated"

    # Ensure Delivery Hours are Updated
    food_partner = FoodPartner.last
    expect(food_partner.delivery_hours.count).to eq 1
    delivery_hours = food_partner.delivery_hours.first
    expect(delivery_hours.start_time).to eq 43200
    expect(delivery_hours.end_time).to eq 72000
    expect(delivery_hours.food_partner).to eq food_partner
  end


private

  def login_to_cake
    visit login_path
    fill_in "authentication_admin_user_session[username]", with: "paulm"
    fill_in "authentication_admin_user_session[password]", with: "password"
    click_button "Login"
    expect(page).to have_content "Enquiries Awaiting Confirmation"
  end

  def navigate_to_new_partner_page
    click_link "Food Partners"
    expect(page).to have_content "Food Partners"
    click_link "Add Food Partner", match: :first
  end

  def fill_in_food_partner_details
    fill_in "food_partner[company_name]", with: "Mad Mex"
    # This is a trix editor
    # fill_in "food_partner[bio]", with: "Biography"
    fill_in "food_partner[url_slug]", with: "mad-mex"
    fill_in "food_partner[contact_first_name]", with: "Maddy"
    fill_in "food_partner[contact_last_name]", with: "The Mexican"
    fill_in "food_partner[email]", with: "partner@example.com"
    fill_in "food_partner[phone_number]", with: "partner@example.com"

    fill_in "food_partner[minimum_spend]", with: "200.00"
    fill_in "food_partner[delivery_cost]", with: "0.00"
    fill_in "food_partner[delivery_text]", with: "Delivers to Sydney CBD, Inner West, Eastern Suburbs"
    fill_in "food_partner[availability_text]", with: "Mon-Fri: 11AM-9PM"
    fill_in "food_partner[lowest_price_dish]", with: "16"

    fill_in "food_partner[lead_time_hours]", with: "1"

    click_link "Add Day"


    select("Monday", from: "food_partner[delivery_hours_attributes][0][day]")
    select("9:00 AM", from: "food_partner[delivery_hours_attributes][0][start_time]")
    select("5:00 PM", from: "food_partner[delivery_hours_attributes][0][end_time]")

    check "food_partner[active]"
  end

  def create_food_partner_through_form
    navigate_to_new_partner_page
    fill_in_food_partner_details
    click_button "Save Food Partner Details"
    expect(page).to have_content "Food Partner Created"
  end

end
