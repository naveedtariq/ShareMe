# language: en

Feature: Sign up

  @wip
  Scenario: Visitor signs up via Facebook
    When I go to the new user registration page
     And I should see link Sign up via Facebook
     And I follow "Sign up via Facebook"
    Then I should be signed in
     And I should be on the dashboard users page
     And I should see /ShareMe code:/
     And my social media contacts are now added and displayed in my profile

  @green
  Scenario: Visitor signs up with valid email
    When I go to the new user registration page
     And I should see "Sign up via Facebook"
     And I fill in "Email" with "test@gmail.com"
     And I fill in "Name" with "Paxtor"
     And I press "Sign up"
    Then I should see "Congratulations! The way you communicate just got upgraded!<br /> A simple 4 digit ShareMe is all you will ever need. Check your email now."
     And "test@gmail.com" should receive 1 emails with subject "Welcome to ShareMe ~ time to upgrade your communications"
    When "test@gmail.com" open the email
     And I click the first link in the email
    Then I should see "You now have your very own 4 digit ShareMe. No more business cards and email addresses just ShareMe"
     And I should be signed in
     And I fill in "Phone number" with "6959750380"
     And I fill in "Password" with "password"
     And I fill in "Password (again)" with "password"
     And I press "Save"
    Then I should see "ShareMe profile updated"
     And I should be on the dashboard users page
     And I should see "ShareMe code:"

  @green
  Scenario: Visitor signs up with invalid email
    When I go to the new user registration page
     And I should see "Sign up via Facebook"
     And I fill in "Email" with ""
     And I press "Sign up"
    Then I should see "Sorry no shady/blank emails allowed"

  @green
  Scenario: Visitor tries to re-activate his or her account from the email link
    When I go to the new user registration page
     And I should see "Sign up via Facebook"
     And I fill in "Email" with "test@gmail.com"
     And I fill in "Name" with "Paxtor"
     And I press "Sign up"
    Then I should see "Congratulations! The way you communicate just got upgraded!<br /> A simple 4 digit ShareMe is all you will ever need. Check your email now."
     And "test@gmail.com" should receive 1 email with subject "Welcome to ShareMe ~ time to upgrade your communications"
    When "test@gmail.com" open the email
     And I click the first link in the email
    Then I should see "You now have your very own 4 digit ShareMe. No more business cards and email addresses just ShareMe"
     And I should be signed in
    When I fill in "Phone number" with "6959750380"
     And I fill in "Password" with "password"
     And I fill in "Password (again)" with "password"
     And I press "Save"
    Then I should see "ShareMe profile updated"
    When I follow "Logout"
    When "test@gmail.com" open the email
     And I click the first link in the email
    Then I should see "Confirmation token inactive"
     And I should not be signed in

  @green
  Scenario: Visitor signs up withs invalid user data
    When I go to the new user registration page
     And I should see "Sign up via Facebook"
     And I fill in "Email" with "test@gmail.com"
     And I fill in "Name" with "Paxtor"
     And I press "Sign up"
     Then I should see "Congratulations! The way you communicate just got upgraded!<br /> A simple 4 digit ShareMe is all you will ever need. Check your email now."
     And "test@gmail.com" should receive 1 email with subject "Welcome to ShareMe ~ time to upgrade your communications"
     When "test@gmail.com" open the email
     And I click the first link in the email
    Then I should see "You now have your very own 4 digit ShareMe. No more business cards and email addresses just ShareMe"
     And I should be signed in
    When I fill in "Phone number" with ""
     And I fill in "Password" with "password"
     And I fill in "Password (again)" with "invalid-password"
     And I press "Save"
    Then I should see error messages:
      | message                                                                  |
      | Everyone (well nearly everyone) has a phone number. Please ShareMe.      |
      | ShareMe detected incorrect passwords. Please try again...2nd time lucky. |

