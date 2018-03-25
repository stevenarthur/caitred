Given /^I am viewing the enquiries index page$/ do
  visit Admin::EnquiriesIndexPage.url
end

Given /^there is an enquiry with the status "(.*?)"$/ do |status|
  create_enquiry_with_status(status)
end

Given /^the customer "(.*?)" creates "(.*?)"$/ do |email, count|
  (0..count.to_i).each do
    create_enquiry_for(email)
  end
end

Given /^the customer "(.*?)" has the following addresses:$/ do |email, table|
  table.hashes.each do |hash|
    ensure_customer_has_address(email, hash['Line 1'], hash['Suburb'], hash['Postcode'])
  end
end

Then /^I see the address set to "(.*?)"$/ do |line_1|
  edit_page = Admin::EditEnquiryPage.new(page)
  expect(edit_page.address_line_1).to eq line_1
end

When /^I add an address$/ do
  edit_page = Admin::EditEnquiryPage.new(page)
  edit_page.add_address
end

When /^I enter the first address line as "(.*?)"$/ do |line_1|
  edit_page = Admin::EditEnquiryPage.new(page)
  edit_page.fill_address_1 line_1
end

When /^I save the address$/ do
  edit_page = Admin::EditEnquiryPage.new(page)
  edit_page.save_address
end

When /^I change the address to "(.*?)"$/ do |address|
  edit_page = Admin::EditEnquiryPage.new(page)
  edit_page.change_address_to address
end

When /^I save the enquiry$/ do
  Admin::EditEnquiryPage.new(page).save_and_confirm_updated
end

When /^I save the invalid enquiry$/ do
  Admin::EditEnquiryPage.new(page).save
end

When /^I save the logistics$/ do
  Admin::EditEnquiryPage.new(page).save_logistics
end

When /^I edit the first enquiry$/ do
  Admin::EnquiriesIndexPage.new(page).edit_first_enquiry
end

When /^I create a new enquiry$/ do
  Admin::EnquiriesIndexPage.new(page).create_enquiry
end

When /^I edit the logistics$/ do
  Admin::EditEnquiryPage.new(page).edit_logistics
end

When /^I enter the address as "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/ do |address1, address2, suburb, postcode|
  edit_page = Admin::EditEnquiryPage.new(page)
  edit_page.fill_address_1 address1
  edit_page.fill_address_2 address2
  edit_page.fill_suburb suburb
  edit_page.fill_postcode postcode
end

When /^I delete the first enquiry$/ do
  Admin::EnquiriesIndexPage.new(page).delete_first_enquiry
end

When /^I enter "(.*?)" in additional delivery info$/ do |info|
  Admin::EditEnquiryPage.new(page).fill_delivery_info(info)
end

When /^I choose "(.*?)" as the event type$/ do |type|
  Admin::EditEnquiryPage.new(page).fill_event_type type
end

When /^I choose "(.*?)" as the customer$/ do |name|
  Admin::EditEnquiryPage.new(page).fill_customer name
end

When /^I set the enquiry attendees to (\d+)$/ do |attendees|
  Admin::EditEnquiryPage.new(page).fill_attendees attendees
end

When /^I set the menu content text to "(.*)"$/ do |content|
  Admin::EditEnquiryPage.new(page).fill_menu_content(content)
end

When /^I edit the enquiry with the status "(.*?)"$/ do |status|
  index_page = Admin::EnquiriesIndexPage.new(page)
  index_page.first_enquiry_with_status(status).edit
end

When /^I click the Progress button$/ do
  Admin::EditEnquiryPage.new(page).progress
end

When /^I click the Regress button$/ do
  Admin::EditEnquiryPage.new(page).regress
end

When /^I click the Mark as Spam button$/ do
  Admin::EditEnquiryPage.new(page).mark_spam
end

When /^I click the Mark as Test button$/ do
  Admin::EditEnquiryPage.new(page).mark_test
end

When /^I click the Mark as Spam button for the enquiry with the status "(.*?)"$/ do |status|
  index_page = Admin::EnquiriesIndexPage.new(page)
  index_page.first_enquiry_with_status(status).mark_spam
end

When /^I click the Mark as Test button for the enquiry with the status "(.*?)"$/ do |status|
  index_page = Admin::EnquiriesIndexPage.new(page)
  index_page.first_enquiry_with_status(status).mark_test
end

When /^I click the Progress button for the Enquiry marked "(.*?)"$/ do |status|
  index_page = Admin::EnquiriesIndexPage.new(page)
  index_page.first_enquiry_with_status(status).progress
end

Then /^I see "(.*?)" enquiries listed in the Awaiting Confirmation table$/ do |count|
  index_page = Admin::EnquiriesIndexPage.new(page)
  expect(index_page.enquiries_awaiting_confirmation.count).to eq count.to_i
end

Then /^I see "(.*?)" enquiries listed in the Awaiting Completion table$/ do |count|
  index_page = Admin::EnquiriesIndexPage.new(page)
  expect(index_page.enquiries_awaiting_completion.count).to eq count.to_i
end

Then /^the enquiry attendees are updated to (\d+)$/ do |attendees|
  enquiry = Admin::EditEnquiryPage.new(page).current_enquiry
  expect(enquiry.event.attendees).to eq attendees
end

Then /^I see "(.*?)" enquiries listed$/ do |number|
  index_page = Admin::EnquiriesIndexPage.new(page)
  expect(index_page.enquiry_count).to eq number.to_i
end

Then /^I see a validation error for customer$/ do
  edit_page = Admin::EditEnquiryPage.new(page)
  expect(edit_page.error_text).not_to be_blank
end

Then /^the enquiry is successfully created$/ do
  edit_page = Admin::EditEnquiryPage.new(page)
  expect(edit_page.successful_create?).to be true
end

Then /^the enquiry event type is updated to "(.*?)"$/ do |type|
  enquiry = Admin::EditEnquiryPage.new(page).current_enquiry
  expect(enquiry.event.type).to eq type
end

Then /^the enquiry menu content is updated to "(.*?)"$/ do |content|
  enquiry = Admin::EditEnquiryPage.new(page).current_enquiry
  expect(enquiry.menu_content).to eq content
end

Then /^the delivery address of the enquiry is updated to "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/ do |address1, address2, suburb, postcode|
  enquiry = Admin::EditEnquiryPage.new(page).current_enquiry
  expect(enquiry.logistics.delivery_address_line_1).to eq address1
  expect(enquiry.logistics.delivery_address_line_2).to eq address2
  expect(enquiry.logistics.delivery_suburb).to eq suburb
  expect(enquiry.logistics.delivery_postcode).to eq postcode
end

Then /^the additional delivery info of the enquiry is set to "(.*?)"$/ do |info|
  enquiry = Admin::EditEnquiryPage.new(page).current_enquiry
  expect(enquiry.logistics.additional_delivery_info).to eq info
end

Then /^there are "(.*?)" enquiries in total$/ do |number|
  expect(total_number_of_enquiries).to eq number.to_i
end

Then /^the enquiry has not been sent to any food partners$/ do
  enquiry_page = Admin::EditEnquiryPage.new(page)
  expect(enquiry_page.not_been_sent?).to be true
end

Then /^I see a status of "(.*?)"$/ do |status|
  enquiry_page = Admin::EditEnquiryPage.new(page)
  expect(enquiry_page.status_title).to eq status
end

Then /^the enquiry status is "(.*?)"$/ do |status|
  enquiry = Admin::EditEnquiryPage.new(page).current_enquiry
  expect(enquiry.status).to eq status
end
