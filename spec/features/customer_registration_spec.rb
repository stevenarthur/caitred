require 'rails_helper'

feature "Customer registers on Caitre'd" do
  let(:customer){ Customer.create!(first_name: 'Paul', last_name: 'Millar',
                                   company_name: "Digital Dawn", telephone: "0425616397",
                                   email: 'paul@digitaldawn.com.au', password: 'password',
                                   created_account: true)  }

  before :each do
    visit register_path
    fill_in_form_fields
  end

  context "email already registered" do
    before :each do
      customer
    end
    context "without js" do
      it "doesn't register" do
        expect(Customer.count).to eq 1
        click_button "Create Account"
        expect(Customer.count).to eq 1
        expect(current_path).to eq register_path
        expect(page).to have_content "It looks like you've already registered with us"
      end
    end

    context "with js" do
      it "doesn't register", js: true do
        expect(Customer.count).to eq 1
        click_button "Create Account"
        expect(Customer.count).to eq 1
        expect(current_path).to eq register_path
        expect(page).to have_content "It looks like you've already registered with us"
        page.save_screenshot("design/customer_registration--email-taken.png", full: true)
      end
    end
  end

  context "email not in system" do
    context "without js" do
      it "registers" do
        expect(Customer.count).to eq 0
        click_button "Create Account"
        expect(Customer.count).to eq 1
        expect(page).to_not have_content "It looks like you've already registered with us"
        expect(page).to have_content("Congratulations! You are now logged in")
      end
    end

    context "with js" do
      it "registers", js: true do
        expect(Customer.count).to eq 0
        page.save_screenshot("design/customer_registration.png", full: true)
        click_button "Create Account"
        expect(Customer.count).to eq 1
        expect(page).to have_selector("#qa-signed-in")
        expect(page).to_not have_content "It looks like you've already registered with us"
        expect(page).to have_content("Congratulations! You are now logged in")
        page.save_screenshot("design/customer_registration--successful.png", full: true)
      end
    end
  end

private

  def fill_in_form_fields
    fill_in "customer[first_name]", with: "Paul"
    fill_in "customer[last_name]", with: "Millar"
    fill_in "customer[company_name]", with: "Digital Dawn"
    fill_in "customer[email]", with: "paul@digitaldawn.com.au"
    fill_in "customer[telephone]", with: "0425616397"
    fill_in "customer[password]", with: "password"
  end

end
