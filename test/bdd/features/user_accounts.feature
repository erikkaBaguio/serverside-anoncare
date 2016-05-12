Feature: User Accounts
  Add, Update, Get User, Get All Users


  Scenario: Retrieve a user's details
      Given user with id '1'
      When  the admin click view user
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'
      And   the following details will be returned
            |fname  |mname    |lname  |email				   |username      |role_id|
            |Remarc |Espinosa |Balisi |remarc.balisi@gmail.com |remarc.balisi |2      |


  Scenario: Retrieve a user's details that does not exist
      Given user with id '30'
      When  the admin click view user
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'No User Found'