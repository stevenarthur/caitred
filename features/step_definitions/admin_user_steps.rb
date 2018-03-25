Given /^there is an admin user with the username "(.*?)" named "(.*?)"$/ do |username, name|
  first_name, last_name = name.split(' ')
  ensure_named_admin_user(username, first_name, last_name)
end

Given /^there is a power user with the username "(.*?)" named "(.*?)"$/ do |username, name|
  first_name, last_name = name.split(' ')
  ensure_named_power_user(username, first_name, last_name)
end

Given /^I am viewing the admin users index page$/ do
  visit Admin::AdminUsersIndexPage.url
end

When /^I edit my profile$/ do
  Admin::Header.new(page).edit_my_profile
end

When /^I reset my password to "(.*?)"$/ do |password|
  Admin::Header.new(page).reset_my_password
  password_page = Admin::ResetPasswordPage.new(page)
  password_page.fill_password(password)
  password_page.submit
end

When /^I add a user$/ do
  Admin::AdminUsersIndexPage.new(page).add_user
end

When /^I delete the user "(.*?)"$/ do |name|
  Admin::AdminUsersIndexPage.new(page).delete_user(name)
end

When /^I edit the user "(.*?)"$/ do |name|
  Admin::AdminUsersIndexPage.new(page).edit_user(name)
end

When /^I log out$/ do
  Admin::Header.new(page).logout
end

When /^I reset the password for "(.*?)" to "(.*?)"$/ do |name, password|
  Admin::AdminUsersIndexPage.new(page).reset_password(name)
  password_page = Admin::ResetPasswordPage.new(page)
  password_page.fill_password(password)
  password_page.submit
end

When /^I enter "(.*?)" as the admin user name$/ do |name|
  first_name, last_name = name.split(' ')
  Admin::EditAdminUserPage.new(page).fill_name(first_name, last_name)
end

When /^I enter "(.*?)" as the admin user username$/ do |username|
  Admin::EditAdminUserPage.new(page).fill_username(username)
end

When /^I enter "(.*?)" as the admin user email address$/ do |email|
  Admin::EditAdminUserPage.new(page).fill_email(email)
end

When /^I enter "(.*?)" as the admin user mobile number$/ do |mobile_number|
  Admin::EditAdminUserPage.new(page).fill_mobile(mobile_number)
end

When /^I enter and confirm "(.*?)" as the password$/ do |password|
  Admin::EditAdminUserPage.new(page).fill_password(password)
end

When /^I save the admin user$/ do
  Admin::EditAdminUserPage.new(page).save
end

When /^I make the user a power user$/ do
  Admin::EditAdminUserPage.new(page).make_power_user
end

When(/^I wait for the user updated message$/) do
  Admin::EditAdminUserPage.new(page).wait_for_updated_message
end

Then /^I can login as "(.*?)" with the password "(.*?)"$/ do |username, password|
  header = Admin::Header.new(page)
  header.logout
  Admin::LoginPage.new(page).login(username, password)
  expect(header.logged_in?).to be true
end

Then /^I see the admin users index page$/ do
  expect(Admin::AdminUsersIndexPage.new(page)).to be_visible
end

Then /^I see an admin user called "(.*?)"$/ do |name|
  expect(Admin::AdminUsersIndexPage.new(page).users_actual_names).to include name
end

Then /^I see a welcome message to "(.*?)"$/ do |name|
  expect(Admin::Header.new(page).welcoming_user).to eq name
end

Then /^there (is|are) "(.*?)" admin (user|users) listed$/ do |_is_are, users, _users_word|
  expect(Admin::AdminUsersIndexPage.new(page).user_count).to eq users.to_i
end

Then /^the user "(.*?)" has the name "(.*?)"$/ do |username, name|
  first_name, last_name = name.split(' ')
  user = find_admin_user(username)
  expect(user.first_name).to eq first_name
  expect(user.last_name).to eq last_name
end

Then /^the user "(.*?)" has the mobile number "(.*?)"$/ do |username, mobile_number|
  user = find_admin_user(username)
  expect(user.mobile_number).to eq mobile_number
end

Then /^the user "(.*?)" is a power user$/ do |username|
  user = find_admin_user(username)
  expect(user.is_power_user).to be true
end

Then /^access to the enquiries page is prevented$/ do
  visit Admin::EnquiriesIndexPage.url
  expect(Admin::LoginPage.new(page)).to be_visible
end
