# language: en

Feature: Sign in
  In order to get access to protected sections of the site
  As a visitor
  I want to sign in

  @green
  Scenario: Visitor is not signed up
    When I go to the login page
     And I fill in "Email" with "email@gmail.com"
     And I fill in "Password" with "password"
     And I press "Sign In"
    Then I should see "Shady password or email. Have you registered yet? 2nd time lucky."
     And I should be on the login page

  @green
  Scenario: Visitor enters wrong password
   Given I am signed up as "email@gmail.com/password" with name "Paxtor"
    When I go to the login page
     And I fill in "Email" with "email@gmail.com.com"
     And I fill in "Password" with "wrongpassword"
     And I press "Sign In"
    Then I should see "Shady password or email. Have you registered yet? 2nd time lucky."
     And I should be on the login page

  @green
  Scenario: Visitor signs in successfully
   Given I am signed up as "email@gmail.com/password" with name "Paxtor"
    When I go to the login page
    Then I should see link Sign up via Facebook
     And I fill in "Email" with "email@gmail.com"
     And I fill in "Password" with "password"
     And I press "Sign In"
    Then I should see "Congrats your in! Welcome to ShareMe."
     And I should be on the dashboard users page

  @green
  Scenario: Visitor signs via Facebook
   Given I am signed up as "paxtor@gmail.com/password" with name "Paxtor"
    When I go to the login page
    Then I should see link Sign up via Facebook
     And I follow "Sign in via Facebook"
    Then I should see "Congrats your in! Welcome to ShareMe."
     And I should be on the dashboard users page

