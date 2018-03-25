Feature: Menus

Background:
  Given I am logged into Cake
  Given there is a food partner called "Orto"
    And there is a food partner called "Mojo Picon"
    And there is a food partner called "Rib Shack"
  And the following menus exist
    | Name      | Food Partner | Event Type     | Active | Minimum Attendees | Price | Tags | Dietary |
    | Brekkie O | Orto         | Breakfast      | true   | 10                | 12    | Hot  | Vegan   |
    | Lunch O   | Orto         | Lunch - Buffet | false  | 15                | 14    |      |         |
    | Dinner O  | Orto         | Dinner         | true   | 10                | 16    | Hot  |         |
    | Brekkie M | Mojo Picon   | Breakfast      | true   | 15                | 18    |      |         |
    | Dinner M  | Mojo Picon   | Dinner         | true   | 10                | 20    |      |         |
    | Brekkie R | Rib Shack    | Breakfast      | false  | 15                | 22    |      |         |
  And a menu filter exists for "Hot"

@javascript
Scenario: View menus page and popup
  Given I view the menus page for all menus
  Then I see "4" menus
  When I click More Info for the "Brekkie O" menu
  Then the menu popup is visible

@javascript
Scenario: Filter menus
  Given I view the menus page for all menus
  When I expand the menu filters
  Then I see the following filters:
    | Filter       |
    | Vegan        |
    | Vegetarian   |
    | Gluten Free  |
    | Hot          |
  And the "Vegetarian" filter is disabled
  When I filter by "Hot"
  Then I see "2" menus

Scenario: View menus for supplier page
  Given I view the menus page for the food partner "Orto"
  Then I see "3" menus

Scenario: View menus for enquiry type
  Given I view the menus page for the event "Breakfast"
  Then I see "2" menus

Scenario: Select menu
  Given I view the menus page for all menus
    When I click Select for the "Brekkie O" menu
    Then I see the enquiry form

@javascript
Scenario: Select menu
  Given I view the menus page for all menus
    When I click Select for the "Brekkie O" menu
    Then I see the enquiry popup

Scenario: Search menus from home page
  Given I am viewing the home page
    When I enter 10 attendees
    And I choose a budget of "$12 - $15"
    And I click to find menus
    Then I see "1" menus

Scenario: Search menus on menu page
    Given I view the menus page for all menus
      When I enter 10 attendees
      And I choose a budget of "$12 - $15"
      And I click to find menus
      Then I see "1" menus

@javascript
Scenario: Go to menu by slug page
  Given I am viewing the menu page for the menu with slug "brekkie-o"
    Then the menu popup is visible
