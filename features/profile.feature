# language: en

Feature: User profile

  Background:
    Given I am signed up as "email@person.com/password" with name "Andrey"
      And there is a user "email@person.com" with attributes:
         | name            | Andrey     |
         | code            | YU24       |
         | phone           | 6959750380 |
         | profile_company | Luck Film  |

  @wip
  Scenario: View my profile
    Given I sign in as "email@person.com/password"
    When I go to the my account page
    Then I should see my data:
      | ShareMe code:     | YU24             |
      | Full name:        | Andrey           |
      | Email:            | email@person.com |
      | Phone Number:     | 6959750380       |
      | Company Name:     | Luck Film        |
      | Adress:           |                  |
      | Twitter account:  |                  |
      | Facebook account: |                  |
      | Linkedin account: |                  |
      | Skype account:    |                  |
     And I should see the following links:
      | Edit profile                 |
      | Contacts                     |
      | Contacts on Map              |
      | Regeneration of ShareMe code |
      | Inviting Friends             |
     And I should see quick statistic my profile:
      | Contacts i have in total | 100 |
      | Contacts removed me      |  10 |
      | Contacts searched for me |  11 |
      | 2nd tier contacts        |  88 |
      | 1st tier contacts        |  12 |


  Scenario: Edit my profile
    Given I sign in as "email@person.com/password"
    When I go to the edit dashboard users page
     And I fill in "Address" with "W 23rd St, New York, USA"
     And I press "Save"
    Then I should see "ShareMe profile updated"

  Scenario: View my contacts on Google Map
    Given the user "email@person.com" has following contacts:
        | name | email         | address                                     |
        | Jinn | jinn@test.com | Vermont, United States                      |
        | Lana | lana@test.com | New York Avenue, Creston, IA, United States |
      And I sign in as "email@person.com/password"
     When I go to the my account page
      And I follow "Contacts on Map"

  @green
  Scenario: Regeneration of ShareMe code
    Given user "email@person.com" has the following contacts:
        | email           | name  |
        | cont1@gmail.com | Nina  |
        | cont2@gmail.com | Dan   |
        | cont3@gmail.com | Jonn  |
        | cont4@gmail.com | Alice |
      And I sign in as "email@person.com/password"
     When I go to the my account page
      And I follow "Regeneration of ShareMe code"
    Given ShareMe code "TW21" already exists
     When I fill in "New code" with "TW21"
      And I press "Save"
     Then I should see "Code 'TW21' already exists. Select one of the variants from the list or enter a new code."
      And I should see "5" code variants that start with /^TW2/
    Given ShareMe code "T3W3" does not exist yet
     When I fill in "New code" with "T3W3"
      And I press "Save"
     Then I should see "Congrats! You just got a new ShareMe. Tell your friends."
      And I should see "T3W3"
      And save and open all text emails
      And "cont1@gmail.com" should receive 1 emails with subject "User Andrey changed ShareMe code."
      And "cont2@gmail.com" should receive 1 emails with subject "User Andrey changed ShareMe code."
      And "cont3@gmail.com" should receive 1 emails with subject "User Andrey changed ShareMe code."
      And "cont4@gmail.com" should receive 1 emails with subject "User Andrey changed ShareMe code."

  @green
  Scenario: Inviting friends
    Given I sign in as "email@person.com/password"
      And a clear email queue
     When I go to the my account page
      And I follow "Inviting Friends"
      And I fill in "Email" with "friend@gmail.com"
      And I press "Send"
     Then "friend@gmail.com" should receive 1 email with subject "I just got ShareMe to simplify my life. 4 digits says it all"
      And "friend@gmail.com" should receive an email with the following body:
        """
        ShareMe Sign Up
        """

  # Scenario: Add account social networks
  #   Given I sign in as "email@person.com/password"
  #    When I go to the my account page
  #     And I follow "Edit"
  #     And I follow "Skype account"
  #     And I fill in "Login" with "my login in skype"
  #     And I fill in "Password" with "skypepassword"
  #     And I press "Save"
  #    Then I should see "ShareME Profile updated."

  @green
  Scenario: Uploading my contacts from file
    Given I sign in as "email@person.com/password"
     When I go to the my account page
      And I follow "Contacts"
      And I follow "Upload contacts"
      And I attach the file "spec/data/contacts.xls" to "file"
      And I press "Upload"
     Then I should be on the dashboard contacts page
      And I should see "Contacts upload."
      And I should see the following contacts:
       | email           | name  |
       | cont1@gmail.com | cont1 |
       | cont2@gmail.com | cont2 |
       | cont3@gmail.com | cont3 |
       | cont4@gmail.com | cont4 |
      Then "cont1@gmail.com" should receive 1 email with subject "I just got ShareMe to simplify my life. 4 digits says it all"
       And "cont2@gmail.com" should receive 1 email with subject "I just got ShareMe to simplify my life. 4 digits says it all"
       And "cont3@gmail.com" should receive 1 email with subject "I just got ShareMe to simplify my life. 4 digits says it all"
       And "cont4@gmail.com" should receive 1 email with subject "I just got ShareMe to simplify my life. 4 digits says it all"

  @green
  Scenario: Adding the not existing contact via profile page
    Given I sign in as "email@person.com/password"
      And ShareMe code "RTHU" does not exist yet
     When I go to the my account page
      And I follow "Contacts"
      And I follow "Add Contact"
      And I fill in "ShareMe code" with "RTHU"
      And I press "Submit"
      Then I should see "Contact not found"

  @green
  Scenario: Adding the existing contact via profile page
    Given I sign in as "email@person.com/password"
      And the following users exist:
         | name | code | email          |
         | Jinn | RTHU | jinn@Gmail.com |
     When I go to the my account page
      And I follow "Contacts"
      And I follow "Add Contact"
      And I fill in "ShareMe code" with "RTHU"
      And I press "Submit"
      Then I should see "Contact added."
      And I should see "Jinn"
      And I should see "jinn@gmail.com"
      And I should see "RTHU"





