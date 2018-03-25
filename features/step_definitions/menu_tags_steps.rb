Given /^I am viewing the menu tags index page$/ do
  visit Admin::MenuTagsIndexPage.url
end

When /^I Generate Menu Tags$/ do
  Admin::MenuTagsIndexPage.new(page).generate_tags
end

Then /^I see "(.*?)" Tags listed$/ do |tag_count|
  tags_page = Admin::MenuTagsIndexPage.new(page)
  expect(tags_page.menu_tags_count).to eq tag_count.to_i
end
