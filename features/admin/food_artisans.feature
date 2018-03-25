Feature: Admin for Food Partners

Background:
  Given there is a food partner called "Orto"
  And there is a food partner called "Mojo Picon"
  And I am logged into Cake

Scenario: List food partners
  Given I am viewing the food partners index page
  Then there are "2" food partners listed
    And the food partner "Orto" is in the list

Scenario: Create new food partner
  Given I am viewing the food partners index page
  When I add a new food partner
    And I enter "Nutty Baker" as the company name
    And I enter "Sweet" as the cuisine
    And I enter "Kylie Minogue" as the contact name
    And I enter "10" as the minimum attendees
    And I enter "100" as the maximum attendees
    And I submit the food partner form
  Then a new food partner called "Nutty Baker" is added
    And the food partner contact name for "Nutty Baker" is "Kylie Minogue"

Scenario: Edit existing food partner
  Given I am viewing the food partners index page
  When I edit the food partner "Mojo Picon"
    And I enter "Mojo Mojo" as the company name
    And I enter "Spanish" as the cuisine
    And I enter "Ricky Martin" as the contact name
    And I enter "15" as the minimum attendees
    And I enter "200" as the maximum attendees
    And I submit the food partner form
  Then the food partner is updated to "Mojo Mojo"
    And the food partner contact name for "Mojo Mojo" is "Ricky Martin"

Scenario: Add menu to food partner
  Given I am editing the food partner "Orto"
  When I edit the menus
    And I add a new menu
    And I enter "Dinner by Orto" as the menu title
    And I enter "Three courses of yum" as the menu short description
    And I enter "20" as the price
    And I choose the "Breakfast, Dinner" event types
    And I make the menu active
    And I save the menu
  Then the food partner "Orto" has a menu called "Dinner by Orto"
  When I edit the menus
    Then the menu "Dinner by Orto" is displayed in the menu list




