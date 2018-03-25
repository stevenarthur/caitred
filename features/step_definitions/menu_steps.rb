Given /^the following menus exist$/ do |table|
  table.hashes.each do |hash|
    active = hash['Active'] == 'true'
    ensure_menu(hash, active)
  end
end

Given /^I view the menus page for all menus$/ do
  visit Web::MenusPage.all_menus
end

Given /^I view the menus page for the food partner "(.*?)"$/ do |food_partner|
  food_partner = FoodPartner.find_by_company_name(food_partner)
  visit Web::MenusPage.menus_for_food_partner(food_partner)
end

Given /^I view the menus page for the event "(.*?)"$/ do |event|
  visit Web::MenusPage.event_menus(event)
end

Given /^I am viewing the menu page for the menu with slug "(.*?)"$/ do |slug|
  visit Web::MenusPage.menu_page_for(slug)
end

When /^I click More Info for the "(.*?)" menu$/ do |menu_title|
  Web::MenusPage.new(page).more_info_for(menu_title)
end

When /^I click Select for the "(.*?)" menu$/ do |menu_title|
  Web::MenusPage.new(page).select(menu_title)
end

When /^I enter (\d+) attendees$/ do |attendees|
  Web::MenusPage.new(page).fill_attendees(attendees)
end

When /^I enter a budget of (\d+)$/ do |budget|
  Web::MenusPage.new(page).fill_budget(budget)
end

When /^I click to find menus$/ do
  Web::MenusPage.new(page).filter_menus
end

When /^I choose a budget of "(.*?)"$/ do |budget|
  Web::MenusPage.new(page).fill_budget(budget)
end

Then /^the menu popup is visible$/ do
  menu_dialog = Web::MenusPage.new(page).dialog
  expect(menu_dialog).to be_visible
end

Then /^I see "(.*?)" menus$/ do |number|
  expect(Web::MenusPage.new(page).menu_count).to eq number.to_i
end

Given /^a menu filter exists for "(.*?)"$/ do |filter_name|
  ensure_menu_filter(filter_name)
end

When /^I expand the menu filters$/ do
  Web::MenusPage.new(page).expand_filters
end

Then /^I see the following filters:$/ do |table|
  menus_page = Web::MenusPage.new(page)
  table.hashes.each do |hash|
    expect(menus_page.filter? hash['Filter']).to eq true
  end
end

Then /^the "(.*?)" filter is disabled$/ do |filter|
  menus_page = Web::MenusPage.new(page)
  expect(menus_page.find_filter(filter)).to be_disabled
end

When /^I filter by "(.*?)"$/ do |filter|
  Web::MenusPage.new(page).filter_by(filter)
end
