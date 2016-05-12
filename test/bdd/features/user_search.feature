# Created by irika-pc at 5/12/2016
Feature: Search user
  As an admin, I want to be able to search user.

  Scenario: Search user
      Given the entered keyword
            |search |
            |Puting |
      When  the admin click search button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'This are all the user(s) matched your search'
      And   the following details will be returned
            |fname    |mname |lname  |email         |role |
            |Muhammad |M     |Puting |mmp@gmail.com |2    |