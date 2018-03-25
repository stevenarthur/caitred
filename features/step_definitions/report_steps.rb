When /^I view the Reports page$/ do
  visit Admin::ReportsIndexPage.url
end

When /^I click the link to the Completed Orders report$/ do
  Admin::ReportsIndexPage.new(page).click_completed_orders
end

Then /^I see a link to the Completed Orders report$/ do
  Admin::ReportsIndexPage.new(page).completed_orders_link?
end

Then /^I see a link to the weekly report$/ do
  Admin::ReportsIndexPage.new(page).weekly_link?
end

Then /^I see a link to the monthly report$/ do
  Admin::ReportsIndexPage.new(page).monthly_link?
end

Then /^I see a link to the customers report$/ do
  Admin::ReportsIndexPage.new(page).customer_link?
end
