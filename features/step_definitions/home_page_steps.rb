Given /^I am viewing the home page$/ do
  visit root_path
end

When /^I click the Enquiry button$/ do
  Web::HomePage.new(page).make_enquiry
end

When /^I click the FAQs link$/  do
  Web::HomePage.new(page).view_faqs
end

When /^I click the Terms link$/  do
  Web::HomePage.new(page).view_terms
end

When /^I click the Privacy link$/  do
  Web::HomePage.new(page).view_privacy
end

When /^I click the Contact Us link$/ do
  Web::HomePage.new(page).view_contact_us
end

When /^I click the About Us link$/ do
  Web::HomePage.new(page).view_about_us
end

When /^I click the Sell With Us link$/ do
  Web::HomePage.new(page).view_sell_with_us
end

When /^I click the Team Lunch link$/ do
  Web::HomePage.new(page).view_team_lunch
end
