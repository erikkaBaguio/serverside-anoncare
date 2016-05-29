Feature: User Accounts
  Add, Update, Get User, Get All Users



# SUNNY CASES

  Scenario: Add a new user to the system - all requirements put
      Given the following details of a user:
            | fname     | mname    | lname     | email                  | username           | password               | role_id|
            | Eleazar   | Timonera | Regencia  | jetregencia@gmail.com  | eleazar.regencia   | josiaheleazarregencia  | 3      |


      And   the username 'eleazar.regencia' does not yet exist
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'Successfully add new user'


  Scenario: Retrieve a user's details
      Given user with id '1'
      When  the admin click view user
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'
      And   the following details will be returned
            |fname  |mname    |lname  |email				   |username      |role_id|
            |Remarc |Espinosa |Balisi |remarc.balisi@gmail.com |remarc.balisi | 3     |


# RAINY CASES
  Scenario: Add a new user to the system - empty inputs
      Given the following details of a user:
            | fname     | mname    | lname     | email                   | username           | password               | role_id|
            | Josiah    |    none  | Regencia  | jawshaeleazar@gmail.com |    none            | josiaheleazarregencia  |  none  |


      And   the username 'josiah.regencia' does not yet exist
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'


  Scenario: Add a new user to the system - email already exists
      Given the following details of a user:
            | fname     | mname    | lname     | email                  | username           | password               | role_id|
            | Josh      | Timonera | Regencia  | jawshaeleazar@gmail.com| josh.regencia      | josiaheleazarregencia  | 3      |


      And   the email 'jawshaeleazar@gmail.com' exists
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Email already exists'


  Scenario: Add a new user to the system - username already exists
      Given the following details of a user:
            | fname     | mname    | lname     | email                  | username           | password               | role_id|
            | Josiah    | Timonera | Regencia  | jawshaeleazar@gmail.com| josiah.regencia    | josiaheleazarregencia  | 3      |


      And   the username 'josiah.regencia' exists
      When  admin clicks the register button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Username already exists'


  Scenario: Retrieve a user's details that does not exist
      Given user with id '30'
      When  the admin click view user
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'No User Found'

  Scenario: User forgets password - email exists
      Given user with email:
            |email                  |
            |jawshaeleazar@gmail.com|

      When  the user submits the form
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'Password Changed!'


  Scenario: User forgets password - no email exists
      Given user with email:
            |email                  |
            |lalalalalala@gmail.com|

      When  the user submits the form
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'ERROR'
      And   it should have a field 'message' containing 'No Email Exists'