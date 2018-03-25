Feature: Admin for Menu Tags

Background:
  Given there is a food partner called "Orto"
    And the following menus exist
      | Name      | Food Partner | Event Type     | Active | Minimum Attendees | Price | Tags   | Dietary |
      | Brekkie O | Orto         | Breakfast      | true   | 10                | 12    | Hot    | Vegan   |
      | Lunch O   | Orto         | Lunch - Buffet | false  | 15                | 14    | Cold   |         |
    And I am logged into Cake

Scenario: Generate Tags
  Given I am viewing the menu tags index page
    When I Generate Menu Tags
    Then I see "2" Tags listed
