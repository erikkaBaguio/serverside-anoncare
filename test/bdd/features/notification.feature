Feature: notification
As a doctor I want to receive a notification after the nurse
has added assessment.

Scenario: Nurse send the assessment to the doctor
          Given the nurse already assess the patient with assessment id 6
          When the nurse request an appointment to the doctor with id 3
          Then I should get '200' response
          And the following details are returned:
            | doctor_id  |assessment_id| is_read |
            | 3    	     | 6           | False   |

Scenario: There is no notification available
          Given the doctor with id 3 click the notification button
          When there is no available notification for doctor with id 3
          Then return a '200' response
          And the following message will pop out No available notifications
