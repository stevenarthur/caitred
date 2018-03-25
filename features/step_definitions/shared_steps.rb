Given /^I am logged into Cake$/ do
  ensure_admin_user('sandra_bullock', 'gravity')
  Admin::LoginPage.new(page).login('sandra_bullock', 'gravity')
end

Given /^I am logged into Cake as "(.*?)"$/ do |username|
  Admin::LoginPage.new(page).login(username)
end
