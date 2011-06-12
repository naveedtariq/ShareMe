# language: en

Feature: Home page
  Background:
    Given I am signed up as "email1@person.com/password" with name "Andrey"
      And there is a user "email1@person.com" with attributes:
         | name            | Andrey     |
         | code            | RT56       |
         | phone           | 6959750380 |
         | profile_company | Luck Film  |

  @green
  Scenario: Signed user search contacts on ShareMe number
    Given I am signed up as "email@gmail.com/password" with name "Paxtor"
     When I go to the home page
      And I fill in "code" with "RT56"
      And I press "Find"
     Then I should see "Are You Human? RT56 wants to ShareMe! To get RT56 contact details please confirm you are in fact human and not a Robot, Alien or Gremlin!"
      And I should see link "Sign up"
      And I should see link Sign in via Facebook
     When I fill in "Email" with "email@gmail.com"
      And I fill in "Password" with "password"
      And I press "Sign In"
     Then I should be on the contact page for ShareMe code "RT56"
      And I should see "Andrey"
      And I should see "RT56"
      And I should see "6959750380"
      And I should see "Luck Film"
      And I should see "email1@person.com"

 @green
 Scenario: Guest search contacts by ShareMe number
    Given a clear email queue
     When I go to the home page
      And I fill in "code" with "RT56"
      And I press "Find"
     Then I should see "Are You Human? RT56 wants to ShareMe! To get RT56 contact details please confirm you are in fact human and not a Robot, Alien or Gremlin!"
      And I should see link "Sign up"
      And I should see link Sign in via Facebook
     When I follow "Sign up"
      And I fill in "Email" with "test@gmail.com"
      And I fill in "Name" with "Paxtor"
      And I press "Sign up"
     Then I should see "Please check your email for RT56 contact details"
      And "test@gmail.com" should receive 1 emails with subject "Welcome to ShareMe ~ time to upgrade your communications"
     When I open the email
      And I click the first link in the email
     Then I should see "You now have your very own 4 digit ShareMe. No more business cards and email addresses just ShareMe"
      And I should be signed in
     When I fill in "Phone number" with "573947366"
      And I fill in "Password" with "password"
      And I fill in "Password (again)" with "password"
      And I press "Save"
     Then I should see "ShareMe profile updated"
      And I should be on the contact page for ShareMe code "RT56"
      And I should see "Andrey"
      And I should see "RT56"
      And I should see "6959750380"
      And I should see "Luck Film"
      And I should see "email1@person.com"
      And contact "email1@person.com" should be added to "test@gmail.com" contacts
      And contact "test@gmail.com" should be added to "email1@person.com" contacts

    @green
    Scenario: Guest search contacts by ShareMe number using Facebook for authorization
     When I go to the home page
      And I fill in "code" with "RT56"
      And I press "Find"
     Then I should see "Are You Human? RT56 wants to ShareMe! To get RT56 contact details please confirm you are in fact human and not a Robot, Alien or Gremlin!"
      And I should see link "Sign up"
      And I should see link Sign in via Facebook
     When I follow "Sign in via Facebook"
     Then I should be signed in
     When I fill in "Phone" with "539647888"
      And I fill in "Password" with "password"
      And I fill in "Password (again)" with "password"
      And I press "Save"
     Then I should see "ShareMe profile updated"
      And I should be on the contact page for ShareMe code "RT56"
      And I should see "Andrey"
      And I should see "RT56"
      And I should see "6959750380"
      And I should see "Luck Film"
      And I should see "email1@person.com"
      And contact "email1@person.com" should be added to "paxtor@gmail.com" contacts
      And contact "paxtor@gmail.com" should be added to "email1@person.com" contacts
