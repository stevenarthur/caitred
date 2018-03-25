Then /^an enquiry email is sent to You Chews$/ do
  email = Emails::EnquiryEmail.new
  expect(email.to_email).to eq Cake::Application.config.youchews_email_to_address
end

Then /^a confirmation email is sent to "(.*?)" at "(.*?)"$/ do |name, email_address|
  email = Emails::ConfirmationEmail.new
  expect(email.to_email).to eq email_address
  expect(email.to_name).to eq name
end

Then /^a supplier enquiry email is sent to "(.*?)"$/ do |company_name|
  to_name = find_food_partner_contact_name(company_name)
  email = Emails::SupplierEnquiryEmail.new
  expect(email.to_name).to eq to_name
end

Then /^the introduction text in the email is "(.*?)"$/ do |intro_text|
  email = Emails::SupplierEnquiryEmail.new
  expect(email.message_html).to include intro_text
end
