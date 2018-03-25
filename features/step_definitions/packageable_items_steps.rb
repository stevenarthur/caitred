Given /^the following packageable items exist$/ do |table|
  table.hashes.each do |hash|
    ensure_packageable_item(hash['Title'], hash['Food Partner'], hash['Type'])
  end
end

Given /^I am viewing the edit packageable items page for "(.*?)"$/ do |food_partner|
  visit Admin::PackageableItemsIndexPage.for_food_partner(food_partner)
end

Then /^there are "(.*?)" packageable items listed$/ do |count|
  expect(Admin::PackageableItemsIndexPage.new(page).item_count).to eq count.to_i
end

When /^I edit the "(.*?)" packageable item$/ do |title|
  Admin::PackageableItemsIndexPage.new(page).edit_item(title)
end

When /^I enter "(.*?)" as the packageable item title$/ do |title|
  Admin::EditPackageableItemPage.new(page).fill_title(title)
end

When /^I enter "(.*?)" as the packageable item description$/ do |description|
  Admin::EditPackageableItemPage.new(page).fill_description(description)
end

When /^I enter "(.*?)" as the packageable item cost$/ do |cost|
  Admin::EditPackageableItemPage.new(page).fill_cost(cost)
end

When /^I save the packageable item$/ do
  Admin::EditPackageableItemPage.new(page).save
end

When /^I add a packageable item$/ do
  Admin::PackageableItemsIndexPage.new(page).add_item
end

When /^I choose "(.*?)" as the packageable item type$/ do |type|
  Admin::EditPackageableItemPage.new(page).choose_type(type)
end

When /^I choose "(.*?)" as the packageable item event types$/ do |event_types|
  edit_page = Admin::EditPackageableItemPage.new(page)
  event_types.split(', ').each do |type|
    edit_page.choose_event_type(EventTypes.find_by_name(type).slug)
  end
end

When /^I delete the packageable item "(.*?)"$/ do |title|
  Admin::PackageableItemsIndexPage.new(page).delete_item(title)
end

When /^I enter "(.*?)" as the packageable item price as extra$/ do |cost|
  Admin::EditPackageableItemPage.new(page).fill_cost_as_extra(cost)
end

Then /^the food partner "(.*?)" has a packageable item called "(.*?)"$/ do |food_partner_name, packageable_item_title|
  item = find_item_by_food_partner_and_title(food_partner_name, packageable_item_title)
  expect(item).not_to be_nil
end

Then /^the packageable item for "(.*?)" called "(.*?)" has a cost of "(.*?)"$/ do |food_partner_name, packageable_item_title, cost|
  item = find_item_by_food_partner_and_title(food_partner_name, packageable_item_title)
  expect(item.cost_string).to eq cost
end
