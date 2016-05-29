# Created by irika-pc at 4/3/2016

Feature: Create final diagnosis
  As a doctor, I want to finalize the diagnosis of the patient.

  Scenario: Update assessment
      Given the details of the patient assessment
            |assessment_id |medications_taken |diagnosis      |recommendation     |
            |31            |test medication   |test diagnosis |test recommendation|

      And   the new details for the patient assessment
            |assessment_id  |medications_taken |diagnosis      |recommendation     |
            |31             |test              |test           |test               |

      When  the doctor clicks the update button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'
