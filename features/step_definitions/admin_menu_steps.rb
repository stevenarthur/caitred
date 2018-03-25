Given /^I am viewing the edit menus page for "(.*?)"$/ do |food_partner|
  visit Admin::EditMenuPackagesPage.for_food_partner(food_partner)
end

Given /^I am editing the "(.*?)" menu for "(.*?)"$/ do |menu, food_partner|
  visit Admin::EditMenuPackagesPage.for_menu(food_partner, menu)
end

Given /^I am viewing the menu packages page for "(.*?)"$/ do |food_partner|
  visit Admin::EditMenuPackagesPage.for_food_partner(food_partner)
end

Given /^the menu "(.*?)" contains the following packageable items$/ do |title, table|
  table.hashes.each do |hash|
    ensure_menu_has_item(title, hash['Title'])
  end
end

Given /^the menu "(.*?)" contains the following extra items$/ do |title, table|
  table.hashes.each do |hash|
    ensure_menu_has_extra_item(title, hash['Title'])
  end
end

Then /^there are "(.*?)" food items listed$/ do |count|
  menu_page = Admin::EditMenuPackagePage.new(page)
  expect(menu_page.food_items_count).to eq count.to_i
end

Then /^there is "(.*?)" extra item listed$/ do |count|
  menu_page = Admin::EditMenuPackagePage.new(page)
  expect(menu_page.extra_items_count).to eq count.to_i
end

Then /^there is "(.*?)" equipment item listed$/ do |count|
  menu_page = Admin::EditMenuPackagePage.new(page)
  expect(menu_page.equipment_items_count).to eq count.to_i
end

When /^I remove "(.*?)" from the extra items$/ do |title|
  item = find_item_by_title(title)
  Admin::EditMenuPackagesPage.new(page).remove_item(item)
end

When /^I enter "(.*?)" as the menu title$/ do |title|
  Admin::EditMenuPackagesPage.new(page).fill_title(title)
end

When /^I enter "(.*?)" as the menu short description$/ do |description|
  Admin::EditMenuPackagesPage.new(page).fill_short_description(description)
end

When /^I enter "(.*?)" as the menu long description$/ do |description|
  Admin::EditMenuPackagesPage.new(page).fill_long_description(description)
end

When /^I enter "(.*?)" as the price$/ do |price|
  Admin::EditMenuPackagesPage.new(page).fill_price(price)
end

When /^I edit the "(.*?)" menu$/ do |title|
  Admin::EditMenuPackagesPage.new(page).edit_menu(title)
end

When /^I enter "(.*?)" as the package conditions$/ do |conditions|
  Admin::EditMenuPackagesPage.new(page).fill_package_conditions(conditions)
end

When /^I enter "(.*?)" as the menu minimum attendees$/ do |attendees|
  Admin::EditMenuPackagesPage.new(page).fill_min_attendees(attendees)
end

When /^I enter "(.*?)" as the menu slug$/ do |slug|
  Admin::EditMenuPackagesPage.new(page).fill_menu_slug(slug)
end

When /^I enter "(.*?)" as the priority order$/ do |priority_order|
  Admin::EditMenuPackagesPage.new(page).fill_priority_order(priority_order)
end

When /^I choose the "(.*?)" event types$/ do |event_types|
  edit_page = Admin::EditMenuPackagesPage.new(page)
  event_types.split(', ').each do |type|
    edit_page.choose_event_type(type)
  end
end

When /^I delete the "(.*?)" menu$/ do |title|
  Admin::EditMenuPackagesPage.new(page).delete_menu(title)
end

When /^I make the menu active$/ do
  Admin::EditMenuPackagesPage.new(page).make_active
end

When /^I save the menu$/ do
  Admin::EditMenuPackagesPage.new(page).save
end

When /^I add a new menu$/ do
  Admin::EditMenuPackagesPage.new(page).add_menu
end

When /^I add "(.*?)" to the included items$/ do |title|
  item = find_item_by_title(title)
  Admin::EditMenuPackagesPage.new(page).add_item(item)
end

When /^I add "(.*?)" to the extra items$/ do |title|
  item = find_item_by_title(title)
  Admin::EditMenuPackagesPage.new(page).add_extra_item(item)
end

When /^I add "(.*?)" to the equipment items$/ do |title|
  item = find_item_by_title(title)
  Admin::EditMenuPackagesPage.new(page).add_equipment_item(item)
end

Then /^the menu "(.*?)" has "(.*?)" included (item|items)$/ do |title, count, _items|
  expect(count_of_menu_items(title)).to eq count.to_i
end

Then /^the menu "(.*?)" has "(.*?)" extra (item|items)$/ do |title, count, _items|
  expect(count_of_extra_food_items(title)).to eq count.to_i
end

Then /^the menu "(.*?)" has "(.*?)" equipment (item|items)$/ do |title, count, _items|
  expect(count_of_equipment_items(title)).to eq count.to_i
end

Then /^the menu "(.*?)" cost is "(.*?)"$/ do |title, cost|
  expect(menu_cost(title)).to eq cost
end

Then /^there are "(.*?)" menus listed$/ do |number|
  expect(Admin::EditMenuPackagesPage.new(page).menu_count).to eq number.to_i
end

Then /^the food partner "(.*?)" has a menu called "(.*?)"$/ do |food_partner_name, menu_title|
  expect(menu_exists?(food_partner_name, menu_title)).to eq true
end

Then /^a new food partner called "(.*?)" is added$/ do |food_partner_name|
  expect(food_partner_exists?(food_partner_name)).to eq true
end

Then /^the menu "(.*?)" is displayed in the menu list$/ do |menu_title|
  menus_page = Admin::EditMenuPackagesPage.new(page)
  expect(menus_page.menu_exists?(menu_title)).to be true
end
