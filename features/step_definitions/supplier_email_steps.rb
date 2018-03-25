When /^I send to "(.*?)"$/ do |company_name|
  Admin::SupplierPreviewEmailPage.new(page).send_for_supplier(company_name)
end

When /^I send the email$/ do
  Admin::SupplierPreviewEmailPage.new(page).send_email
end

When /^I enter introduction text of "(.*?)"$/ do |intro|
  Admin::SupplierPreviewEmailPage.new(page).fill_intro_text(intro)
end

When /^I click on the select food partners tab$/ do
  Admin::EditEnquiryPage.new(page).choose_food_partners
end

When /^I preview and edit the email to "(.*?)"$/ do |company_name|
  Admin::EditEnquiryPage.new(page).preview_supplier_email(company_name)
end
