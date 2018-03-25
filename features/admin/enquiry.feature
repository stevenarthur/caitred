Feature: Admin for Enquiries

Background:
  Given there are "3" enquiries already created
    And there is a customer with the email "rodstewart@hotmail.com" called "Rod Stewart"
  And I am logged into Cake

Scenario: List enquiries
  Given I am viewing the enquiries index page
  Then I see "3" enquiries listed

Scenario: View enquiry
  Given I am viewing the enquiries index page
    When I edit the first enquiry
    Then I see a status of "New"

@javascript
Scenario: Validate presence of customer
  Given I am viewing the enquiries index page
  When I create a new enquiry
    And I save the invalid enquiry
  Then I see a validation error for customer

@javascript
Scenario: Update enquiry
  Given I am viewing the enquiries index page
  When I edit the first enquiry
    And I set the enquiry attendees to 20
    And I set the menu content text to "Some food $20\nMore food $10"
    And I save the enquiry
  Then the enquiry attendees are updated to 20
    And the enquiry menu content is updated to "Some food $20\nMore food $10"
