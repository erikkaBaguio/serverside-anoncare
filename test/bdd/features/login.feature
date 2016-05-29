# Created by irika-pc at 5/29/2016
Feature: Login
  As an admin/nurse/doctor, I want to login to the website so that I can access the system.

  ###############
  # Sunny Cases #
  ###############

    Scenario: user successfully logged in
        Given the login requirements
              |username       |password  |
              |muhammad.puting|admin     |

        When  the clicks the login button
        Then  it should have a '200' response
        And   it should have a field 'status' containing 'OK'
        And   it should have a field 'message' containing 'Successfully logged in'