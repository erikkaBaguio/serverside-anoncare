Feature: User Accounts
  Add, Update, Get User, Get All Users


########
# SUNNY CASES
########
  Scenario: Retrieve a user's details
    Given user with id '1'
    When the admin enter with an id '1'
    Then it should have a '200' response
    And it should have a field 'status' containing 'OK'
    And it should have a field 'message' containing 'OK'
    And the following user details will be returned:
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
  	