Given /^there is a poll called "(.*?)" with answers$/ do |poll_name, table|
  ensure_poll(poll_name, table.hashes)
end

Given /^I am viewing the polls index page$/ do
  visit Admin::PollsIndexPage.url
end

Then /^there is "(.*?)" poll listed$/ do |poll_count|
  index_page = Admin::PollsIndexPage.new(page)
  expect(index_page.poll_count).to eq poll_count.to_i
end

Then /^I see a poll called "(.*?)"$/ do |poll_name|
  index_page = Admin::PollsIndexPage.new(page)
  expect(index_page.contains? poll_name).to eq true
end

When /^I add a poll$/ do
  Admin::PollsIndexPage.new(page).add_poll
end

When /^I set the poll name to "(.*?)"$/ do |title|
  Admin::PollsIndexPage.new(page).fill_title(title)
end

When /^I save the poll$/ do
  Admin::PollsIndexPage.new(page).save_poll
end

Then /^there are "(.*?)" polls in the database$/ do |expected_poll_count|
  expect(poll_count).to eq expected_poll_count.to_i
end

When /^I edit the poll "(.*?)"$/ do |poll_name|
  Admin::PollsIndexPage.new(page).edit_poll(poll_name)
end

Then /^there is a poll called "(.*?)"$/ do |title|
  expect(find_poll(title)).not_to be_nil
end
