Then /^I see the Thank You page$/ do
  expect(Web::ThankYouPage.new(page).heading?).to be true
end
