Feature: Admin for Admin Users

Background:
  Given there is an admin user with the username "david_beckham" named "David Beckham"
    And there is a power user with the username "lady_gaga" named "Lady Gaga"
  And I am logged into Cake as "lady_gaga"

Scenario: List admin users
  Given I am viewing the admin users index page
  Then there are "2" admin users listed
    And I see an admin user called "David Beckham"

Scenario: Log out
  Given I am viewing the admin users index page
  When I log out
  Then access to the enquiries page is prevented

@javascript
Scenario: Edit admin user
  Given I am viewing the admin users index page
  When I edit the user "David Beckham"
    And I enter "Victoria Beckham" as the admin user name
    And I enter "5555" as the admin user mobile number
    And I make the user a power user
    And I save the admin user
    And I wait for the user updated message
  Then the user "david_beckham" has the name "Victoria Beckham"
    And the user "david_beckham" has the mobile number "5555"
    And the user "david_beckham" is a power user

Scenario: Reset password for admin user
  Given I am viewing the admin users index page
  When I reset the password for "David Beckham" to "new_password"
  Then I can login as "david_beckham" with the password "new_password"

Scenario: Edit own admin user profile
  When I edit my profile
  And I enter "Nicky Minaj" as the admin user name
    And I save the admin user
  Then I see a welcome message to "Nicky"

Scenario: Reset own admin password
  When I reset my password to "new_password"
  Then I can login as "lady_gaga" with the password "new_password"

@javascript
Scenario: Create new admin user
  Given I am viewing the admin users index page
  When I add a user
    And I enter "London Grammar" as the admin user name
    And I enter "london_grammar" as the admin user username
    And I enter "5555" as the admin user mobile number
    And I enter and confirm "password" as the password
    And I enter "london@grammar.com" as the admin user email address
    And I save the admin user
  Then I see the admin users index page
    And I see an admin user called "London Grammar"

Scenario: Delete admin user
  Given I am viewing the admin users index page
  When I delete the user "David Beckham"
  Then there is "1" admin user listed
