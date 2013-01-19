Feature: Recover Password

  Scenario: request to have my password reset
    Given I signed up
     When I request to have my password reset
     Then I should see a success message

  Scenario: recover my password after receiving instructions
    Given I signed up 
     When I request to have my password reset
      And I reset my password
     Then I should see a success message

  Scenario: atttempt to reset a password for a non user
    When I request a new password for a non user
    Then I should see form errors
