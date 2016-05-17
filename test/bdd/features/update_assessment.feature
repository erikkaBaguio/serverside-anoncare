# Created by irika-pc at 4/3/2016

Feature: Create final diagnosis
  As a doctor, I want to finalize the diagnosis of the patient.

  Scenario: Update assessment
      Given the details of the patient assessment with an id 3
            |id |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
            |1  |20000000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |3                   |

      And   the new details for the patient assessment with an id 3
            |id |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
            |1  |20000000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |ok             |ok                  |3                   |

      When  the doctor clicks the update button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'
