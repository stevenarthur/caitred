require "rails_helper"

feature "Customer can sign up" do

  it "signs up" do
    visit register_path
    fill_in "customer[first_name]", with: "Paul"
    fill_in "customer[last_name]", with: "Paul"
    fill_in "customer[company_name]", with: "Digital Dawn"
    fill_in "customer[email]", with: "paul@digitaldawn.com.au"
    fill_in "customer[telephone]", with: "0425616397"
    fill_in "customer[password]", with: "password"
    click_button "Create Account"
    expect(page).to have_content("Congratulations! You are now logged in")
  end
  
  it "signs up with underscore in email" do
    visit register_path
    fill_in "customer[first_name]", with: "Paul"
    fill_in "customer[last_name]", with: "Paul"
    fill_in "customer[company_name]", with: "Digital Dawn"
    fill_in "customer[email]", with: "paul_millar@digitaldawn.com.au"
    fill_in "customer[telephone]", with: "0425616397"
    fill_in "customer[password]", with: "password"
    click_button "Create Account"
    expect(page).to have_content("Congratulations! You are now logged in")
  end

end
