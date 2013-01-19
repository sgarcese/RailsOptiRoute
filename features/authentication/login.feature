Feature: Log in

  Scenario: login successfully
    Given I signed up
     When I log in
     Then I should see a success message

  Scenario: login with incorrect credentials
    Given I signed up
     When I log in with the wrong credentials
     Then I should see a failure message