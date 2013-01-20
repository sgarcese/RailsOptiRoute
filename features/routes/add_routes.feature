Feature: Add Routes
  
  Background:
    Given I signed up
     When I log in

  Scenario: add a new route
     When I add a route with 2 locations
     Then I should see a success message

  Scenario: attempt to add a route with less than 2 routes
     When I add a route with 1 location
     Then I should see form errors

  Scenario: attempt to add a route without a name
    Given I am on the new route page
     When I add a route without a name
     Then I should see form errors

  Scenario: view a list of routes
    Given I have 2 routes
     When I go to the routes page
     Then I should see a list of routes

  Scenario: view a single route
    Given I created an "awesome" route
     When I go to the "awesome" route page
     Then I should see "Route: awesome"
