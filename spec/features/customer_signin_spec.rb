require 'rails_helper' 

feature "Customer can sign in" do
  let(:customer){ Customer.create!(first_name: 'Paul', last_name: 'Millar', telephone: '0425616397',
                                   email: 'paul@paulmillar.net', password: 'password',
                                   created_account: true)  }

  before(:each) do
    customer
  end

  context "with javascript" do
    it "signs in", js: true do
      visit customer_login_path
      fill_in "authentication_customer_session[email]", with: customer.email
      fill_in "authentication_customer_session[password]", with: 'password'
      click_button "Sign in"
      expect(page).to have_selector("#qa-signed-in")
    end
  end

  context "without javascript" do
    it "signs in" do
      visit customer_login_path
      fill_in "authentication_customer_session[email]", with: customer.email
      fill_in "authentication_customer_session[password]", with: 'password'
      click_button "Sign in"
      expect(page).to have_selector("#qa-signed-in")
    end
  end

end
