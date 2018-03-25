Given /^the "(.*?)" menu already has "(.*?)" menu items$/ do |menu_title, number|
  ensure_menu_with_items(menu_title, number.to_i)
end

Given /^the "(.*?)" menu already has "(.*?)" extra items$/ do |menu_title, number|
  ensure_menu_with_extra_items(menu_title, number.to_i)
end

Given /^the "(.*?)" menu already "(.*?)" equipment items$/ do |menu_title, number|
  ensure_menu_with_equipment_items(menu_title, number.to_i)
end

Then /^the "(.*?)" menu is active$/ do |menu_title|
  menu = find_menu(menu_title)
  expect(menu.active).to be true
end

Then /^the "(.*?)" menu has "(.*?)" menu item$/ do |menu_title, number|
  expect(menu_item_count(menu_title)).to eq number.to_i
end

Then /^the "(.*?)" menu has "(.*?)" extra item$/ do |menu_title, number|
  expect(extra_item_count(menu_title)).to eq number.to_i
end

Then /^the "(.*?)" menu has "(.*?)" equipment item$/ do |menu_title, number|
  expect(equipment_item_count(menu_title)).to eq number.to_i
end

Then /^the "(.*?)" menu has a menu item called "(.*?)"$/ do |menu_title, item_title|
  expect(menu_item_exists(menu_title, item_title)).to be true
end

Then /^the "(.*?)" menu has an extra item called "(.*?)"$/ do |menu_title, item_title|
  expect(extra_item_exists(menu_title, item_title)).to be true
end

Then /^the "(.*?)" menu has an equipment item called "(.*?)"$/ do |menu_title, item_title|
  expect(equipment_item_exists(menu_title, item_title)).to be true
end
