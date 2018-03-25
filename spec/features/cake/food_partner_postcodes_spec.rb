require 'rails_helper'

feature "Food Partner Postcodes" do
  let(:sydney_postcode){ Postcode.create!(zipcode: 2000, title: "Sydney CBD") }
  let(:food_partner){ create(:food_partner) }
  let(:admin){ Authentication::AdminUser.create!(first_name: "Paul", last_name: "Millar", 
                                                 username: "paulm", password: 'password', 
                                                 password_confirmation: 'password',
                                                 email_address: 'paul@paulmillar.net', 
                                                 mobile_number: '0425616397', is_power_user: true) } 

  before :each do
    admin
    visit login_path
    fill_in "authentication_admin_user_session[username]", with: "paulm"
    fill_in "authentication_admin_user_session[password]", with: "password"
    click_button "Login"
    expect(page).to have_content "Enquiries Awaiting Confirmation"
  end

  context "removal" do

    before :each do
      food_partner.postcodes << sydney_postcode
      food_partner.save
    end

    it "can removes a postcode", js: true do
      visit edit_food_partner_path(food_partner.id)
      expect(page).to have_content("Sydney CBD")
      expect(food_partner.postcodes).to eq [sydney_postcode]
      within("#qa--#{sydney_postcode.id}") do
        click_link "X"
      end
      expect(page).to_not have_content("Sydney CBD")
      food_partner.reload
      expect(food_partner.postcodes).to eq []
    end
  end

end
