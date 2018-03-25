require 'rails_helper'

feature 'Partner requests to be on platform' do

  it 'sends enquiry' do
    visit sell_with_us_path

    fill_in "delivery", with: "Yes"
    fill_in "name", with: "Violet Partner"
    fill_in "company_name", with: "Burger Fuel"
    fill_in "website", with: 'https://www.burgerfuel.com'
    fill_in "email", with: "violet@burgerfuel.com"
    fill_in "phone", with: "0425616397"
    fill_in "delivery", with: "0425616397"
    fill_in "more_info", with: "0425616397"

    click_button "Apply to Join"

  end

end
