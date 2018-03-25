Feature: Accessing Reports

Background:
  Given I am logged into Cake
    And there are "3" enquiries already created and completed
    And I view the Reports page


Scenario: View Index
  Then I see a link to the Completed Orders report
    And I see a link to the weekly report
    And I see a link to the monthly report
    And I see a link to the customers report

Scenario: View Confirmed Orders Report
  When I click the link to the Completed Orders report
    Then I see "3" enquiries listed
