Feature: Setting address for an enquiry

Background:
  Given there is a customer with the email "rodstewart@hotmail.com" called "Rod Stewart"
    And the customer "rodstewart@hotmail.com" has the following addresses:
      | Line 1      | Suburb    | Postcode |
      | 1 Main St   | Sydney    | 2000     |
      | 2 Park Lane | Melbourne | 3000     |
    And the customer "rodstewart@hotmail.com" creates "1"
  And I am logged into Cake

Scenario: View enquiry address
  Given I am viewing the enquiries index page
    When I edit the first enquiry
    Then I see the address set to "1 Main St, Sydney, 2000"

@javascript
Scenario: Add enquiry address
  Given I am viewing the enquiries index page
    When I edit the first enquiry
    When I add an address
    And I enter the first address line as "1 high street"
    And I save the address
    Then I see the address set to "1 high street"

