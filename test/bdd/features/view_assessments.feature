# Created by irika-pc at 5/12/2016
Feature: View Assessment
  As a doctor, I want to view all assessments of a patient.


  ###############
  # Sunny Cases #
  ###############

  Scenario: View Assessment of Patient
      Given the patient assessment with an assessment id '1'
      When  the doctor click view button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   the following details will be returned
            |assessment_id|assessment_date       |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint     |history_of_present_illness  |medications_taken  |diagnosis       |recommendation       |attending_physician |
            |1            |2016-05-10 19:59:14.46|20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint  |test history                |test medication    |test diagnosis  |test recommendation  |1                   |



  Scenario: View All Assessment of A Patient
      Given the assessment of patient with school id '20130000'
      When  the doctor click search button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'
      And   it should have a field 'count' containing '9'
      And 	the following details will be returned
            |assessment_id |assessment_date       |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint     |history_of_present_illness  |medications_taken  |diagnosis       |recommendation       |attending_physician |
            |1             |2016-05-10 19:59:14.46|20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint  |test history                |test medication    |test diagnosis  |test recommendation  |1                   |
            |2             |2016-05-10 19:59:14.46|20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint1 |test history1               |test medication1   |test diagnosis1 |test recommendation1 |3                   |
            |3             |2016-05-10 19:59:14.46|20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint  |test history                |test medication    |test diagnosis  |test recommendation  |3                   |


  ##############
  # Rainy Case #
  ##############

  Scenario: View All Assessment of A Patient
      Given the assessment of patient with school id '1000000'
      When  the doctor click search button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'School ID does not exist.'


  Scenario: View All Assessment of A Patient
      Given the assessment of patient with school id '0'
      When  the doctor click search button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please input school ID.'