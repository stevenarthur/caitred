Feature: Place enquiry for menu

Background:
  Given there is a food partner called "Orto"
  And the following menus exist
    | Name      | Food Partner | Event Type   | Active |
    | Brekkie O | Orto         | Breakfast    | true   |
  And the following packageable items exist
    | Title            | Food Partner | Type      | Cost | Cost as Extra |
    | Sandwich platter | Orto         | food      | 3.00 | 5.00          |
    | Mixed nuts       | Orto         | food      | 2.50 | 4.00          |
    | Frittata         | Orto         | food      | 3.00 | 4.00          |
    | Napkins          | Orto         | equipment | 3.00 | 4.00          |
  And the menu "Brekkie O" contains the following packageable items
    | Title            |
    | Sandwich platter |
    | Frittata         |
    And the menu "Brekkie O" contains the following extra items
    | Title      |
    | Mixed nuts |
    | Napkins    |

@javascript
Scenario: Place enquiry with menu
  Given I am viewing the enquiry form for "Brekkie O" menu
    And I enter my email address as "bruno@hotmail.com"
    And I enter my name as "Bruno Mars"
    And I choose "Mixed nuts" as extras
    And I enter my address as "400 George St, Sydney, CBD, 2000"
    And I enter parking instructions of "Park outside"
  When I submit the enquiry form
  Then I see the Thank You page
    And an enquiry email is sent to You Chews

@javascript
Scenario: Create account and place a second order via page
  Given I have submitted an enquiry form with these details
    | Menu      | Email         | First Name | Last Name | Address Line 1 | Suburb |
    | Brekkie O | john@blah.com | John       | Smith     | 1 Main St      | Sydney |
  When I enter and confirm the password "Password"
    And I submit the create account form
    Then I see the Thank You for registering page
  When I am viewing the enquiry form for "Brekkie O" menu
  Then I see my contact details in the enquiry form as
    | Email         | Name           |
    | john@blah.com | John Smith     |
  And I see my address details in the enquiry form as
    | Address Line 1 | Suburb |
    | 1 Main St      | Sydney |
  When I submit the enquiry form
  Then I see the Thank You page
    And an enquiry email is sent to You Chews

@javascript
Scenario: Create account and place a second order via popup
  Given I have submitted an enquiry form via the popup with these details
    | Menu      | Email         | First Name | Last Name | Address Line 1 | Suburb |
    | Brekkie O | john@blah.com | John       | Smith     | 1 Main St      | Sydney |
  When I enter and confirm the password "Password"
    And I submit the create account form
    Then I see the Thank You for registering page
  When I view the menus page for all menus
    And I click Select for the "Brekkie O" menu
    And I see the enquiry popup
  Then I see my contact details in the enquiry form as
    | Email         | Name        |
    | john@blah.com | John Smith  |
  And I see my address details in the enquiry form as
    | Address Line 1 | Suburb |
    | 1 Main St      | Sydney |
  When I submit the enquiry form
  Then I see the Thank You page
    And an enquiry email is sent to You Chews
