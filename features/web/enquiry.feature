Feature: Place enquiry

Scenario: Access enquiry form from home page
  Given I am viewing the Contact Us page
  When I click the Enquiry link
  Then I see the enquiry form

@javascript
Scenario: Validate email
  Given I am viewing the enquiry form
  When I submit the enquiry form
  Then validation for the enquiry form fails
    And email address is required
  When I enter my email address as "bruno@hotmail.com"
    And I enter my name as "Bruno Mars"
    And I submit the enquiry form
  Then I see the Thank You page
    And an enquiry email is sent to You Chews

@javascript
Scenario: Place enquiry with all fields filled
  Given I am viewing the enquiry form
    When I show the calendar
      And I choose next "Friday" as my event date
    When I show the clock
      And I choose "6pm" as my event time
    And I enter "20" attendees
    And I enter a budget of '$200'
    And I enter my name as "Bruno Mars"
    And I enter my email address as "bruno@hotmail.com"
    And I enter my phone number as "09876"
    And I choose not to be added to the mailing list
    And I enter "nothing else" that you need to know
  When I submit the enquiry form
  Then I see the Thank You page
    And an enquiry email is sent to You Chews

