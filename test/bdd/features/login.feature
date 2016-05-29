# Created by irika-pc at 5/29/2016
Feature: Login
  As an admin/nurse/doctor, I want to login to the website so that I can access the system.

  ###############
  # Sunny Case  #
  ###############

    Scenario: Logged in successfully
        Given the following credentials
              |username       |password  |
              |muhammad.puting|admin     |

        When  the login button is clicked
        Then  it should have a '200' response
        And   it should have a field 'status' containing 'OK'
        And   it should have a field 'message' containing 'Successfully logged in'


  ###############
  # Rainy Cases #
  ###############

    Scenario: Empty password field
        Given the following credentials
              |username       |password  |
              |muhammad.puting|          |

        When  the login button is clicked
        Then  it should have a '200' response
        And   it should have a field 'status' containing 'FAILED'
        And   it should have a field 'message' containing 'Invalid username or password'


    Scenario: Empty password field
        Given the following credentials
              |username       |password  |
              |               |     |

        When  the login button is clicked
        Then  it should have a '200' response
        And   it should have a field 'status' containing 'FAILED'
        And   it should have a field 'message' containing 'Invalid username or password'