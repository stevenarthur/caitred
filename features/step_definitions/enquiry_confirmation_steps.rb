Given /^there is a ready to confirm enquiry$/ do |table|
  details = table.rows_hash
  create_ready_to_confirm_enquiry(details)
end

When /^I view the confirm enquiry page for the customer "(.*)"$/ do |email|
  visit Web::EnquiryConfirmationPage.url_for_customer_email(email)
end

Then /^I see the order number on the confirmation page$/ do
  confirmation = Web::EnquiryConfirmationPage.new(page)
  expect(confirmation.order_number?).to eq true
end

Then /^I see "(.*?)" event date on the confirmation page$/ do |event_date|
  confirmation = Web::EnquiryConfirmationPage.new(page)
  expect(confirmation.event_date).to eq event_date
end

Then /^I see "(.*?)" event time on the confirmation page$/ do |event_time|
  confirmation = Web::EnquiryConfirmationPage.new(page)
  expect(confirmation.event_time).to eq event_time
end

Then /^I see "(.*?)" attendees on the confirmation page$/ do |attendees|
  confirmation = Web::EnquiryConfirmationPage.new(page)
  expect(confirmation.attendees).to eq attendees
end

Then /^I see "(.*?)" menu title on the confirmation page$/ do |menu_title|
  confirmation = Web::EnquiryConfirmationPage.new(page)
  expect(confirmation.menu_title).to eq menu_title
end

Then /^I see "(.*?)" menu contents on the confirmation page$/ do |customer_menu_content|
  confirmation = Web::EnquiryConfirmationPage.new(page)
  expect(confirmation.customer_menu_content).to eq customer_menu_content
end

When /^I confirm my order without checking card details$/ do
  confirmation = Web::EnquiryConfirmationPage.new(page)
  confirmation.confirm
end

Then /^I see the Thanks for Confirming page$/ do
  thanks = Web::ThanksConfirmedPage.new(page)
  expect(thanks).to be_visible
end
