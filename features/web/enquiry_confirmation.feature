Feature: Enquiry Confirmation

Background:
  Given there is a customer user
    | Email         | Password | First Name | Last Name |
    | blah@blah.com | password | John       | Smith     |


@javascript
Scenario: Confirm Enquiry
  Given there is a ready to confirm enquiry
    | Customer   |  blah@blah.com |
    | Event Date |  2 Dec 2014    |
    | Event Time |  2:30pm         |
    | Attendees  |  50             |
    | Menu Title |  Banh Mis       |
    | Menu Contents | lots of sangers |
    | Payment Method | Credit Card |
  When I view the confirm enquiry page for the customer "blah@blah.com"
  Then I see the order number on the confirmation page
    And I see "2 December 2014" event date on the confirmation page
    And I see "2:30pm" event time on the confirmation page
    And I see "50" attendees on the confirmation page
    And I see "Banh Mis" menu title on the confirmation page
    And I see "lots of sangers" menu contents on the confirmation page
  When I accept the terms and conditions
  And I confirm my order without checking card details
  Then I see the Thanks for Confirming page

@javascript
Scenario: Confirm Invoiced Enquiry
  Given there is a ready to confirm enquiry
    | Customer   |  blah@blah.com |
    | Event Date |  2 Dec 2014    |
    | Event Time |  2:30pm         |
    | Attendees  |  50             |
    | Menu Title |  Banh Mis       |
    | Menu Contents | lots of sangers |
    | Payment Method | Single EFT Invoice |
  When I view the confirm enquiry page for the customer "blah@blah.com"
  Then I see the order number on the confirmation page
    And I see "2 December 2014" event date on the confirmation page
    And I see "2:30pm" event time on the confirmation page
    And I see "50" attendees on the confirmation page
    And I see "Banh Mis" menu title on the confirmation page
    And I see "lots of sangers" menu contents on the confirmation page
  When I accept the terms and conditions
  And I confirm my order without checking card details
  Then I see the Thanks for Confirming page
