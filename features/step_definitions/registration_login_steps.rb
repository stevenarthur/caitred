Given /^there is a customer user$/ do |table|
  table.hashes.each do |hash|
    ensure_customer_user(hash['Email'], hash['Password'], hash['First Name'], hash['Last Name'])
  end
end

When /^I enter and confirm the password "(.*?)"$/ do |password|
  thank_you = Web::ThankYouPage.new(page)
  thank_you.fill_password(password)
  thank_you.fill_password_confirmation(password)
end

Then /^I see the Thank You for registering page$/ do
  expect(Web::ThanksForRegistering.new(page).loaded?).to be true
end

When /^I click the login link$/ do
  Web::WelcomeBox.new(page).click_login_link
end

When /^I enter "(.*?)" as my email$/ do |email|
  Web::LoginPage.new(page).fill_email(email)
end

When /^I enter "(.*?)" as my password$/ do |password|
  Web::LoginPage.new(page).fill_password(password)
end

When /^I submit the login form$/ do
  Web::LoginPage.new(page).submit
end

Then /^I end up on the home page$/ do
  expect(Web::HomePage.new(page).loaded?).to eq true
end

Then /^I see a welcome message saying "(.*?)"$/ do |message|
  expect(Web::WelcomeBox.new(page).message).to eq message
end

Given /^I am logged in as "(.*?)" with password "(.*?)"$/ do |email, password|
  visit Web::LoginPage.url
  Web::LoginPage.new(page).fill_email(email)
  Web::LoginPage.new(page).fill_password(password)
  Web::LoginPage.new(page).submit
end

When /^I click the logout link$/ do
  Web::WelcomeBox.new(page).click_logout_link
end

When /^I click the register link$/ do
  Web::WelcomeBox.new(page).click_register_link
end

When /^I enter "(.*?)" as my email to register$/ do |email|
  Web::RegisterPage.new(page).fill_email(email)
end

When /^I enter and confirm "(.*?)" as my password$/ do |password|
  Web::RegisterPage.new(page).fill_password(password)
  Web::RegisterPage.new(page).fill_password_confirmation(password)
end

When /^I enter "(.*?)" as my first name$/ do |first_name|
  Web::RegisterPage.new(page).fill_first_name(first_name)
end

When /^I enter "(.*?)" as my last name$/ do |last_name|
  Web::RegisterPage.new(page).fill_last_name(last_name)
end

When /^I submit the registration form$/ do
  Web::RegisterPage.new(page).submit
end

Given /^I am viewing the login page$/ do
  visit Web::LoginPage.url
end

When /^I click the reset password link$/ do
  Web::LoginPage.new(page).click_reset_password_link
end

When /^I enter my email address "(.*?)" to reset the password$/ do |email|
  Web::ResetPasswordPage.new(page).fill_email(email)
end

When /^I submit the reset password form$/ do
  Web::ResetPasswordPage.new(page).submit
end

Then /^I see a message saying my password has been reset$/ do
  reset_page = Web::PasswordHasBeenResetPage.new(page)
  expect(reset_page.loaded?).to eq true
end

Then /^I get an email to "(.*)" with a link to reset my password$/ do |email_address|
  email = Emails::ResetPasswordEmail.new
  expect(email.to_email).to eq email_address
end
