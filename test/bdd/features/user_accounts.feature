Feature: User Accounts
  Add, Update, Get User, Get All Users


########
# SUNNY CASES
########
  Scenario: Add a new user to the system - all requirements put
    Given the following details of a user:
        | fname     | mname    | lname     | email                   | username           | password               | role_id|
        | Josiaha   | Timonera | Regencia  | jawshaeleazar@gmail.com | josiaha.regencia   | josiaheleazarregencia  | 3      |


    And   the username 'josiah.regencia' does not yet exist
    When  admin clicks the register button
    Then it should have a '200' response
    And it should have a field 'status' containing 'OK'
    And it should have a field 'message' containing 'Successfully add fname'

  Scenario: Retrieve a user's details
    Given user with id '2'
    When the admin enter with an id '2'
    Then it should have a '200' response
    And it should have a field 'status' containing 'OK'
    And it should have a field 'message' containing 'OK'
    And the following details will be returned
    |fname |mname   |lname |email				   |username|role_id|
    |remarc|espinosa|balisi|remarc.balisi@gmail.com|app-user|	2	|


########
# RAINY CASES
########
  Scenario: Retrieve a user's details that does not exist
  	Given user with id '30'
  	When the admin enter with an id '30'
  	Then it should have a '200' response
  	And it should have a field 'status' containing 'FAILED'
  	And it should have a field 'message' containing 'No User Found'
  	