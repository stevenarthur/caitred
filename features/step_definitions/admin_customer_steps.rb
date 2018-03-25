Given /^there is a customer with the email "(.*?)" called "(.*?)"$/ do |email, name|
  first_name, last_name = name.split(' ')
  ensure_customer(email, first_name, last_name)
end

Given /^I am viewing the customers index page$/ do
  visit Admin::CustomersIndexPage.url
end

Given /^"(.*?)" enquiries are created for the customer "(.*?)"$/ do |number_of_enquiries, email|
  (1..number_of_enquiries.to_i).each do
    create_enquiry_for(email)
  end
end

When /^I add an enquiry for "(.*?)"$/ do |name|
  Admin::CustomersIndexPage.new(page).add_enquiry_for(name)
end

When /^I view enquiries for "(.*?)"$/ do |name|
  Admin::CustomersIndexPage.new(page).view_enquiries_for(name)
end

Then /^there are "(.*?)" customers listed$/ do |count|
  expect(Admin::CustomersIndexPage.new(page).customer_count).to eq count.to_i
end

Then /^I see a customer called "(.*?)"$/ do |name|
  expect(Admin::CustomersIndexPage.new(page).customer_names).to include name
end

Then /^the index page shows the customer "(.*?)" has "(.*?)" (enquiry|enquiries)$/ do |name, number_of_enquiries, _enquiries|
  enquiry_count = Admin::CustomersIndexPage.new(page).enquiry_count_for(name)
  expect(enquiry_count).to eq number_of_enquiries.to_i
end

Then /^the customer "(.*?)" has "(.*?)" (enquiry|enquiries)$/ do |name, enquiry_count, _enquiries|
  first_name, last_name = name.split(' ')
  enquiries = get_enquiries_for_customer(first_name, last_name)
  expect(enquiries.size).to eq enquiry_count.to_i
end

Then /^I see a list of "(.*?)" enquiries for "(.*?)"$/ do |enquiry_count, name|
  enquiries_page = Admin::CustomerEnquiriesPage.new(page)
  expect(enquiries_page.customer_name).to eq name
  expect(enquiries_page.enquiry_count).to eq enquiry_count.to_i
end
