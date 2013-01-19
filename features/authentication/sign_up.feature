Feature: Sign Up

  Scenario: sign up as a new user
    Given I am on the signup page
     When I signup
     Then I should see a success message

  Scenario: sign up as someone who is already a user
    Given I am on the signup page
    Given the following users exist:
      | email            |
      | test@example.com |

     When I signup as "test@example.com"
     Then I should see form errors

  Scenario: attempt to signup with a password that is too short
    Given I am on the signup page
     When I signup with too short of a password
     Then I should see form errors