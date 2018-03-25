Feature: Workflow for Enquiries

Background:
  Given there is an enquiry with the status "New"
    And there is an enquiry with the status "Processing"
    And there is an enquiry with the status "Waiting on Supplier"
    And there is an enquiry with the status "Ready to Confirm"
    And there is an enquiry with the status "Confirmed"
    And there is an enquiry with the status "Delivered"
    And there is an enquiry with the status "Completed"
    And there is an enquiry with the status "Spam"
    And there is an enquiry with the status "Cancelled"
    And there is an enquiry with the status "Test"
    And I am logged into Cake

@javascript
Scenario: New enquiries can be marked as Spam on the Index page
  When I click the Mark as Spam button for the enquiry with the status "New"
  Then the enquiry status is "Spam"

@javascript
Scenario: Processing enquiries can be marked as Spam on the Enquiry page
  When I edit the enquiry with the status "Processing"
  When I click the Mark as Spam button
  Then the enquiry status is "Spam"

@javascript
Scenario: New enquiries can be marked as Test on the Enquiry page
  When I edit the enquiry with the status "New"
  When I click the Mark as Test button
  Then the enquiry status is "Test"

@javascript
Scenario: Processing enquiries can be marked as Test on the Index page
  When I click the Mark as Test button for the enquiry with the status "Processing"
  Then the enquiry status is "Test"

@javascript
Scenario: Enquiry can be moved through the workflow on Enquiry page
  When I edit the enquiry with the status "New"
  When I click the Progress button
  Then the enquiry status is "Processing"

@javascript
Scenario: Enquiry can be moved backward through the workflow on Enquiry page
  When I edit the enquiry with the status "Processing"
  When I click the Regress button
  Then the enquiry status is "New"

@javascript
Scenario: Enquiry can be moved through the workflow on Index page
  When I click the Progress button for the Enquiry marked "Ready to Confirm"
  Then the enquiry status is "Confirmed"

@javascript
Scenario: Only Awaiting Confirmation Enquiries show on the index page
  Then I see "4" enquiries listed in the Awaiting Confirmation table

@javascript
Scenario: All non-delivered enquiries have a Cancel button on the index page
  Then I see "2" enquiries listed in the Awaiting Completion table
