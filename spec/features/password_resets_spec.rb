require 'rails_helper'

feature 'password resets' do
  let(:customer){ Customer.create!(first_name: 'Paul', last_name: 'Millar', email: 'paul@millar.com',
                                   password: 'password', telephone: '0425616397') } 

  context "valid" do
    before(:each){ customer } 
    it "sends the user a reset password email and sets a password reset token" do
      visit new_password_reset_path
      expect(page).to have_content "Reset your password"
      fill_in "email", with: 'paul@millar.com'
      click_button "Reset Password"
      expect(page).to have_content "Thank you, please check your email for instructions on how to reset your password."
    end

    context "when a user is invalid, it still allows them to reset their password" do
      # https://bugsnag.com/digital-dawn/youchews/errors/57209ffd848d0daeb536fedd0
      # Validation failed: Last name can't be blank, Telephone can't be blank
      it "sends the user a reset password email and sets a password reset token" do
        invalid_customer = Customer.new(first_name: 'Paul', email: 'paul@paul.net', password: 'password');
        invalid_customer.save(validate: false)

        visit new_password_reset_path
        expect(page).to have_content "Reset your password"
        fill_in "email", with: 'paul@paul.net'
        click_button "Reset Password"
        expect(page).to have_content "Thank you, please check your email for instructions on how to reset your password."
      end

      it "updates resets the customers password" do
        invalid_customer = Customer.new(first_name: 'Paul', email: 'paul@paul.net', password: 'password');
        invalid_customer.assign_attributes(password_reset_token: SecureRandom.urlsafe_base64(30), 
                                          reset_token_created: Time.now)
        invalid_customer.save(validate: false)
        visit reset_customer_password_path(token: invalid_customer.password_reset_token)
        expect(page).to have_content "Please enter and confirm a new password."
        fill_in "password", with: 'newpassword'
        fill_in "password_confirmation", with: 'newpassword'
        click_button "Reset Password"
        expect(page).to have_content "your password has been reset"
      end
    end

  end

  context "invalid" do
    it "when a user isn't found, it notifies the user that the email was invalid" do
      visit new_password_reset_path
      expect(page).to have_content "Reset your password"
      fill_in "email", with: 'not-an-email@millar.com'
      click_button "Reset Password"
      expect(page).to_not have_content "Thank you, please check your email for instructions on how to reset your password."
      expect(page).to have_content "Your email address could not be found in our system."
      expect(page).to have_content "Reset your password"
    end
  end

end
