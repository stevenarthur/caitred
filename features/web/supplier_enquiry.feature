Feature: Supplier Enquiry

Scenario: View Sell With Us
  Given I am viewing the home page
  When I click the Sell With Us link
  Then I see the Sell With Us page

Scenario: Submit supplier enquiry
  Given I am viewing the Sell With Us page
  When I enter "xxx" as my supplier contact name
  And I submit the supplier enquiry
  Then I see the thank you page for supplier enquiries
