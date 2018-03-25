Feature: Admin for Packageable Items

Background:
  Given there is a food partner called "Orto"
    And the following packageable items exist
    | Title            | Food Partner |
    | Sandwich platter | Orto         |
    | Mixed nuts       | Orto         |
    | Frittata         | Orto         |
    | Cookies          | Orto         |
  And I am logged into Cake

  Scenario: List packageable items
    Given I am viewing the edit packageable items page for "Orto"
    Then there are "4" packageable items listed

  Scenario: Edit existing packageable item
    Given I am viewing the edit packageable items page for "Orto"
    When I edit the "Sandwich platter" packageable item
      And I enter "Platter of Sandwiches" as the packageable item title
      And I enter "Smoked salmon and cucumber sandwiches" as the packageable item description
      And I enter "3.50" as the packageable item cost
      And I enter "5.00" as the packageable item price as extra
      And I choose "food" as the packageable item type
      And I choose "Morning Tea, Breakfast" as the packageable item event types
      And I save the packageable item
    Then the food partner "Orto" has a packageable item called "Platter of Sandwiches"
      And the packageable item for "Orto" called "Platter of Sandwiches" has a cost of "$3.50"


  Scenario: Add packageable item
    Given I am viewing the edit packageable items page for "Orto"
    When I add a packageable item
      And I enter "Lemon tarts" as the packageable item title
      And I enter "Lemon filled cakes very yum" as the packageable item description
      And I enter "2.00" as the packageable item cost
      And I enter "5.00" as the packageable item price as extra
      And I choose "food" as the packageable item type
      And I choose "Lunch, Dinner" as the packageable item event types
      And I save the packageable item
    Then the food partner "Orto" has a packageable item called "Lemon tarts"
      And the packageable item for "Orto" called "Lemon tarts" has a cost of "$2"

  Scenario: Delete packageable items
    Given I am viewing the edit packageable items page for "Orto"
    When I delete the packageable item "Sandwich platter"
    Then there are "3" packageable items listed
