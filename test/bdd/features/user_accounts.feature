Feature: User Accounts
  Add, Update, Get User, Get All Users


  Scenario: Add a new user to the system - all requirements put
      Given the following details of a user:
            | fname     | mname    | lname     | email                  | username           | password               | role_id|
            | Eleazaaa  | Timonera | Regencia  | joregecia@gmail.com   | eleazaaa.regencia  | josiaheleazarregencia  | 3      |


      And   the username 'josiah.regencia' does not yet exist
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'Successfully add new user'


########
# SUNNY CASES
########


  Scenario: Add a new user to the system - empty inputs
      Given the following details of a user:
            | fname     | mname    | lname     | email                   | username           | password               | role_id|
            | Josiah    |    None  | Regencia  | jawshaeleazar@gmail.com |      Null          | josiaheleazarregencia  | 3      |


      And   the username 'josiah.regencia' does not yet exist
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'


    Scenario: Add a new user to the system - email already exists
      Given the following details of a user:
            | fname     | mname    | lname     | email                  | username           | password               | role_id|
            | Eleazaaa  | Timonera | Regencia  | jawshaeleazar@gmail.com| eleazaaa.regencia  | josiaheleazarregencia  | 3      |


      And   the email 'jawshaeleazar@gmail.com' exists
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Email already exists'


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