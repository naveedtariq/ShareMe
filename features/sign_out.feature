# language: en

Feature: Sign out
  In order to protect my account from unauthorized access
  As a signed in user
  I want to sign out

  @green
  Scenario: User signs out
   Given I am signed up as "email@gmail.com/password" with name "Paxtor"
     And I sign in as "email@gmail.com/password"
    When I follow "Logout"
    Then I should be on the home page
     And I should see "You gotta ShareMe before continuing. Please sign up or login to continue?"
