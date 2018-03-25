Feature: Admin for Customers

Background:
  Given there is a customer with the email "maryjblige@hotmail.com" called "MaryJ Blige"
    And there is a customer with the email "rodstewart@hotmail.com" called "Rod Stewart"
  And I am logged into Cake

Scenario: List customers
  Given I am viewing the customers index page
  Then there are "2" customers listed
    And I see a customer called "MaryJ Blige"

@javascript
Scenario: create enquiry for customer
  Given I am viewing the customers index page
  When I add an enquiry for "MaryJ Blige"
    And I save the enquiry
    Then the customer "MaryJ Blige" has "1" enquiry

Scenario: list enquiries for customer
  Given "2" enquiries are created for the customer "maryjblige@hotmail.com"
    And I am viewing the customers index page
    Then the index page shows the customer "MaryJ Blige" has "2" enquiries
  When I view enquiries for "MaryJ Blige"
    Then I see a list of "2" enquiries for "MaryJ Blige"
