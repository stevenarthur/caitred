Feature: Admin for Polls

Background:
  Given there is a poll called "My Poll" with answers
    | ID                                   | Order | Answer Text |
    | 2a213bba-7307-4033-8159-c2afa57966cd | 1     | Yes         |
    | 2a213bba-7307-4033-8159-c2afa57966ce | 1     | No          |
    | 2a213bba-7307-4033-8159-c2afa57966cf | 1     | Maybe       |
  And I am logged into Cake

Scenario: List Polls
  Given I am viewing the polls index page
  Then there is "1" poll listed
    And I see a poll called "My Poll"

Scenario: Create new poll
  Given I am viewing the polls index page
  When I add a poll
    And I set the poll name to "My New Poll"
    And I save the poll
    Then there are "2" polls in the database

Scenario: Update poll
  Given I am viewing the polls index page
  When I edit the poll "My Poll"
    And I set the poll name to "New Poll title"
    And I save the poll
  Then there is a poll called "New Poll title"
