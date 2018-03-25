Given /^I am viewing the Sell With Us page$/ do
  visit Web::SupplierEnquiryForm.url
end

When /^I enter "(.*)" as my supplier contact name$/ do |name|
  Web::SupplierEnquiryForm.new(page).fill_name name
end

When /^I submit the supplier enquiry$/ do
  Web::SupplierEnquiryForm.new(page).submit
end

Then /^I see the thank you page for supplier enquiries$/ do
  expect(Web::ThankYouPage.new(page).heading?).to be true
end
