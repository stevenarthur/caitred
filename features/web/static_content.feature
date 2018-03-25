Feature: Static Content

Scenario: View FAQs
  Given I am viewing the home page
  When I click the FAQs link
  Then I see the FAQs page

Scenario: View Terms and Conditions
  Given I am viewing the home page
  When I click the Terms link
  Then I see the Terms page

Scenario: View Privacy Policy
  Given I am viewing the home page
  When I click the Privacy link
  Then I see the Privacy page

Scenario: View Contact Us
  Given I am viewing the home page
  When I click the Contact Us link
  Then I see the Contact Us page

Scenario: View About Us
  Given I am viewing the home page
  When I click the About Us link
  Then I see the About Us page

Scenario: View Team Building page
  Given I am viewing the home page
  When I click the Team Lunch link
  Then I see the Team Lunch page
