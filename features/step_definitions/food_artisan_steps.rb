Given /^there is a food partner called "(.*?)"$/  do |company_name|
  ensure_food_partner(company_name)
end

Given /^I am viewing the food partners index page$/ do
  visit Admin::FoodPartnersIndexPage.url
end

Given /^I am editing the food partner "(.*?)"$/ do |name|
  visit Admin::EditFoodPartnersPage.url_for(name)
end

When /^I edit the food partner "(.*?)"$/ do |name|
  Admin::FoodPartnersIndexPage.new(page).edit(name)
end

When /^I add a new food partner$/ do
  Admin::FoodPartnersIndexPage.new(page).add
end

When /^I edit the menus$/ do
  Admin::EditFoodPartnersPage.new(page).edit_menus
end

When /^I enter "(.*?)" as the company name$/ do |name|
  Admin::EditFoodPartnersPage.new(page).fill_company(name)
end

When /^I enter "(.*?)" as the cuisine$/ do |cuisine|
  Admin::EditFoodPartnersPage.new(page).fill_cuisine(cuisine)
end

When /^I enter "(.*?)" as the contact name$/ do |name|
  Admin::EditFoodPartnersPage.new(page).fill_name(name)
end

When /^I enter "(.*?)" as the minimum attendees$/ do |min|
  Admin::EditFoodPartnersPage.new(page).fill_min_attendees(min)
end

When /^I enter "(.*?)" as the maximum attendees$/ do |max|
  Admin::EditFoodPartnersPage.new(page).fill_max_attendees(max)
end

When /^I submit the food partner form$/ do
  Admin::EditFoodPartnersPage.new(page).submit
end

Then /^the food partner contact name for "(.*?)" is "(.*?)"$/ do |company_name, contact_name|
  name = find_food_partner_contact_name(company_name)
  expect(name).to eq contact_name
end

Then /^there are "(.*?)" food partners listed$/ do |expected_count|
  count = Admin::FoodPartnersIndexPage.new(page).number_of_partners
  expect(count).to eq expected_count.to_i
end

Then /^the food partner "(.*?)" is in the list$/ do |company_name|
  partners = Admin::FoodPartnersIndexPage.new(page).all_company_names
  expect(partners).to include(company_name)
end

Then /^the food partner is updated to "(.*?)"$/ do |food_partner_name|
  food_partner = Admin::EditFoodPartnersPage.new(page).current_food_partner
  expect(food_partner.company_name).to eq food_partner_name
end
