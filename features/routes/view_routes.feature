Feature: View Routes

  Background:
    Given I signed up
     When I log in

  Scenario: view a list of routes
    Given I have 2 routes
     When I go to the routes page
     Then I should see a list of routes

  Scenario: view a single route
    Given I created an "awesome" route
     When I go to the "awesome" route page
     Then I should see "Route: awesome"