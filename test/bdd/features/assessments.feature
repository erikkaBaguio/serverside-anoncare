# Created by irika-pc at 5/9/2016
Feature: Assessment
  As a nurse, I want to assess the patient.

  Scenario: Create assessment successfully.
      Given the nurse have the following assessment details:
                | school_id | age | temperature | pulse_rate  | respiration_rate  | blood_pressure  | weight |chief_complaint |history_of_present_illness | medications_taken | diagnosis   | recommendation | attending_physician|
                | 20130000  | 19  | 37.1        | 80          | 19                | 90/70           | 48.5   | complaint      | history                   | medication1       | diagnosis1  | recommendation1| 1                  |

      And   school id '20130000' exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'