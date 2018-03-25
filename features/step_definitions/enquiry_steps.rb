Given /^I am viewing the enquiry form$/ do
  visit Web::EnquiryForm.enquiry
end

Given /^I am viewing the enquiry form for "(.*?)" menu$/ do |menu_title|
  visit Web::EnquiryForm.enquiry_for_menu(menu_title)
end

Given /^there (is|are) "(.*?)" (enquiry|enquiries) already created$/ do |_is_are, number_of_enquiries, _enquiries|
  (1..number_of_enquiries.to_i).each do
    create_enquiry
  end
end

Given /^there (is|are) "(.*?)" (enquiry|enquiries) already created and completed$/ do |_is_are, number_of_enquiries, _enquiries|
  (1..number_of_enquiries.to_i).each do
    create_completed_enquiry
  end
end

Given /^I have submitted an enquiry form with these details$/ do |table|
  details = table.hashes[0]
  visit Web::EnquiryForm.enquiry_for_menu(details['Menu'])
  form = Web::EnquiryForm.new(page)
  form.fill_email(details['Email'])
  form.fill_first_name(details['First Name'])
  form.fill_last_name(details['Last Name'])
  form.fill_address_line_1(details['Address Line 1'])
  form.fill_address_suburb(details['Suburb'])
  form.submit
end

Given(/^I have submitted an enquiry form via the popup with these details$/) do |table|
  visit Web::MenusPage.all_menus
  details = table.hashes[0]
  Web::MenusPage.new(page).select(details['Menu'])
  form = Web::EnquiryPopup.new(page)
  form.fill_email(details['Email'])
  form.fill_first_name(details['First Name'])
  form.fill_last_name(details['Last Name'])
  form.fill_address_line_1(details['Address Line 1'])
  form.fill_address_suburb(details['Suburb'])
  Web::EnquiryForm.new(page).submit
end

When /^I submit the enquiry form$/ do
  Web::EnquiryForm.new(page).attempt_submit
end

When /^I submit the popup enquiry form$/ do
  Web::EnquiryPopup.new(page).submit
end

When /^I show the calendar$/ do
  form = Web::EnquiryForm.new(page)
  form.show_calendar
  expect(form.calendar).to be_visible
end

When /^I show the clock$/ do
  form = Web::EnquiryForm.new(page)
  form.show_clock
  expect(form.clock).to be_visible
end

When /^I choose next "(.*?)" as my event date$/ do |day_of_week|
  date = Time.now.next_week(day_of_week.downcase.to_sym)
  Web::EnquiryForm.new(page).fill_event_date(date)
end

When /^I choose "(.*?)" as my event time$/ do |time_string|
  time = Time.parse(time_string)
  Web::EnquiryForm.new(page).fill_event_time(time)
end

When /^I enter a budget of '\$(\d+)'$/ do |budget|
  Web::EnquiryForm.new(page).fill_budget(budget)
end

When /^I choose "(.*?)" food$/ do |food_choices|
  form = Web::EnquiryForm.new(page)
  food_choices.split(',').each do |choice|
    form.add_food_choice(choice.strip)
  end
end

When /^I choose "(.*?)" dietary requirements$/ do |dietary_requirements|
  form = Web::EnquiryForm.new(page)
  dietary_requirements.split(',').each do |requirement|
    form.add_dietary_requirement(requirement.strip)
  end
end

When /^I enter "(.*?)" in the dietary requirements text$/ do |dr_text|
  Web::EnquiryForm.new(page).fill_dietary_requirements_text(dr_text)
end

When /^I choose "(.*?)" as extras$/ do |extras_list|
  form = Web::EnquiryForm.new(page)
  extras_list.split(',').each do |extra|
    form.add_extra(extra.parameterize)
  end
end

When /^I enter my address as "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/ do |address_line_1, address_line_2, suburb, postcode|
  form = Web::EnquiryForm.new(page)
  form.fill_address_1(address_line_1)
  form.fill_address_2(address_line_2)
  form.fill_suburb(suburb)
  form.fill_postcode(postcode)
end

When /^I enter my name as "(.*?)"$/ do |name|
  name = name.split(' ')
  Web::EnquiryForm.new(page).fill_first_name(name[0])
  Web::EnquiryForm.new(page).fill_last_name(name[1])
end

When /^I enter my company name as "(.*?)"$/ do |company|
  Web::EnquiryForm.new(page).fill_company(company)
end

When /^I enter my email address as "(.*?)"$/ do |email|
  Web::EnquiryForm.new(page).fill_email(email)
end

When /^I enter my phone number as "(.*?)"$/ do |phone|
  Web::EnquiryForm.new(page).fill_phone(phone)
end

When /^I choose "(.*?)" as my preferred communication$/ do |comm_pref|
  Web::EnquiryForm.new(page).fill_comm_preference(comm_pref)
end

When /^I choose not to be added to the mailing list$/ do
  Web::EnquiryForm.new(page).opt_out_of_mailings
end

When /^I enter "(.*?)" that you need to know$/ do |additional_info|
  Web::EnquiryForm.new(page).fill_additional_info(additional_info)
end

When /^I accept the terms and conditions$/ do
  Web::EnquiryForm.new(page).accept_terms
end

When /^I enter my address as "(.*?)"$/ do |address|
  address_args = address.split(', ')
  Web::EnquiryForm.new(page).fill_address_line_1(address_args[0])
  Web::EnquiryForm.new(page).fill_address_line_2(address_args[1])
  Web::EnquiryForm.new(page).fill_address_suburb(address_args[2])
  Web::EnquiryForm.new(page).fill_address_postcode(address_args[3])
end

When /^I enter parking instructions of "(.*?)"$/ do |parking_instructions|
  Web::EnquiryForm.new(page).fill_address_parking_information(parking_instructions)
end

When /^I edit the address$/ do
  Web::EnquiryForm.new(page).edit_address
end

When /^I submit the create account form$/ do
  Web::ThankYouPage.new(page).submit
end

When /^I add a new address$/ do
  Web::EnquiryForm.new(page).add_address
end

Then /^I see my contact details in the enquiry form as$/ do |table|
  details = table.hashes[0]
  enquiry_form = Web::EnquiryForm.new(page)
  expect(enquiry_form.contact_name).to eq details['Name']
  expect(enquiry_form.contact_email).to eq details['Email']
end

Then /^I see my address details in the enquiry form as$/ do |table|
  details = table.hashes[0]
  enquiry_form = Web::EnquiryForm.new(page)
  expect(enquiry_form.address_line_1).to eq details['Address Line 1']
  expect(enquiry_form.address_suburb).to eq details['Suburb']
end

Then /^I see the enquiry popup$/ do
  expect(Web::EnquiryPopup.new(page)).to be_visible
end

Then /^validation for the enquiry form fails$/ do
  expect(Web::EnquiryForm.new(page).validation_errors?).to be true
end

Then /^email address is required$/ do
  expect(Web::EnquiryForm.new(page).validation_errors).to include('Please enter a valid email address.')
end

Then /^accepting the terms is required$/ do
  expect(Web::EnquiryForm.new(page).validation_errors).to include('Please accept the terms and conditions')
end

Then /^I see the enquiry form$/ do
  expect(Web::EnquiryForm.new(page).heading?).to be true
end

Then /^I see the enquiry form for "(.*?)" menu$/ do |menu_title|
  form = Web::EnquiryForm.new(page)
  expect(form.heading?).to be true
  expect(form.menu_panel.heading).to include menu_title
end

Then /^I enter "(.*?)" attendees$/ do |attendees|
  Web::EnquiryForm.new(page).fill_attendees(attendees.to_i)
end
