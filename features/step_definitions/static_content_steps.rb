Then /^I see the FAQs page$/  do
  expect(Web::ContentPage.new(page).heading_text).to eq 'Frequently Asked Questions'
end

Then /^I see the Privacy page$/ do
  expect(Web::ContentPage.new(page).heading_text).to eq 'Privacy Policy'
end

Then /^I see the Terms page$/ do
  expect(Web::ContentPage.new(page).heading_text).to eq 'Website Terms of Use'
end

Then /^I see the Contact Us page$/ do
  expect(Web::ContentPage.new(page).heading_text).to eq 'Contact Us'
end

Then /^I see the About Us page$/ do
  expect(Web::ContentPage.new(page).heading_text).to eq 'About Us'
end

Then /^I see the Sell With Us page$/ do
  expect(Web::ContentPage.new(page).heading_text).to eq 'Sell With Us'
end

Given /^I am viewing the Contact Us page$/ do
  page.visit Web::ContactUsPage.url
end

When /^I click the Enquiry link$/ do
  Web::ContactUsPage.new(page).click_enquiry_link
end

Then /^I see the Team Lunch page$/ do
  expect(Web::ContentPage.new(page).heading_text).to include 'Find the way to your team'
end
