Feature: Admin for Menus

Background:
  Given there is a food partner called "Orto"
    And the following menus exist
    | Name      | Food Partner | Event Type   | Active |
    | Brekkie O | Orto         | Breakfast    | false  |
    | Lunch O   | Orto         | Lunch Buffet | false  |
    | Dinner O  | Orto         | Dinner       | true   |
    And the following packageable items exist
    | Title            | Food Partner | Type      | Cost | Cost as Extra |
    | Sandwich platter | Orto         | food      | 3.00 | 5.00          |
    | Mixed nuts       | Orto         | food      | 2.50 | 4.00          |
    | Frittata         | Orto         | food      | 3.00 | 4.00          |
    | Blini            | Orto         | food      | 2.00 | 4.50          |
    | Napkins          | Orto         | equipment | 3.00 | 4.00          |
    | Cutlery          | Orto         | equipment | 1.50 | 2.50          |
    And the menu "Brekkie O" contains the following packageable items
    | Title            |
    | Sandwich platter |
    | Frittata         |
    And the menu "Brekkie O" contains the following extra items
    | Title      |
    | Mixed nuts |
    | Napkins    |
  And I am logged into Cake

Scenario: List existing menu packages
  Given I am viewing the menu packages page for "Orto"
    Then there are "3" menus listed

@javascript
Scenario: Add new menu package
  Given I am viewing the menu packages page for "Orto"
  When I add a new menu
    And I enter "New Brekkie" as the menu title
    And I enter "Three courses of yum" as the menu short description
    And I enter "Lots and lots of yummy food" as the menu long description
    And I enter "26" as the price
    And I choose the "Breakfast, Dinner" event types
    And I enter "20" as the menu minimum attendees
    And I enter "choose 2" as the package conditions
    And I enter "menu-slug" as the menu slug
    And I enter "50" as the priority order
    And I make the menu active
    And I add "Sandwich platter" to the included items
    And I add "Frittata" to the included items
    And I add "Mixed nuts" to the extra items
    And I add "Napkins" to the equipment items
    And I save the menu
  Then the menu "New Brekkie" has "2" included items
    And the menu "New Brekkie" has "1" extra item
    And the menu "New Brekkie" has "1" equipment item
    And the menu "New Brekkie" cost is "$26"

@javascript
Scenario: Edit menu package
  Given I am viewing the menu packages page for "Orto"
  When I edit the "Brekkie O" menu
    Then there are "2" food items listed
    And there is "1" extra item listed
    And there is "1" equipment item listed
  When I add "Blini" to the included items
    And I add "Cutlery" to the equipment items
    And I remove "Mixed nuts" from the extra items
    And I save the menu
  Then the menu "Brekkie O" has "3" included items
    And the menu "Brekkie O" has "2" equipment items
    And the menu "Brekkie O" has "0" extra items

Scenario: Delete existing menu
  Given I am viewing the menu packages page for "Orto"
  When I delete the "Lunch O" menu
  Then there are "2" menus listed

