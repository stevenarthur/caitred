Feature: Registration and log in

Background:
  Given there is a customer user
    | Email         | Password | First Name | Last Name |
    | blah@blah.com | password | John       | Smith     |

Scenario: Log in
  Given I am viewing the home page
  When I click the login link
    And I enter "blah@blah.com" as my email
    And I enter "password" as my password
    And I submit the login form
    Then I end up on the home page
    And I see a welcome message saying "Welcome, John"

Scenario: Log out
  Given I am logged in as "blah@blah.com" with password "password"
  When I click the logout link
  Then I see a welcome message saying "Welcome!"

@javascript
Scenario: Register
  Given I am viewing the home page
    When I click the register link
    And I enter "blah@blah.com" as my email to register
    And I enter and confirm "password" as my password
    And I enter "James" as my first name
    And I enter "Bond" as my last name
    And I submit the registration form
    Then I see the Thank You for registering page
    And I see a welcome message saying "Welcome, James"

Scenario: Reset password
  Given I am viewing the login page
    When I click the reset password link
    And I enter my email address "blah@blah.com" to reset the password
    And I submit the reset password form
    Then I see a message saying my password has been reset
    And I get an email to "blah@blah.com" with a link to reset my password
