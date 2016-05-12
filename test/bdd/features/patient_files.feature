<<<<<<< HEAD
# Created by Sha-el Regencia at 10/05/2016
Feature: Patient Files
  # Enter feature description here

  Scenario: Create patient file - All inputs valid
    Given the following details of patient
    |school_id| fname       | mname  | lname    |age| sex    | department_id| patient_type_id|height | weight | date_of_birth  | civil_status |name_of_guardian|home_address         |smoking|allergies|alcohol |medications_taken|drugs|cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge  |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem  |hepatitis_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness|
    |20130034 | Kristel     |Daligdig|Pabillaran|19 |female  |    1         |     1          | 5 ft  | 45     | August 20 1996 | single       | Corazon Aquino | Dalipuga Iligan City|slight |chicken  |drunkard| paracetamol     |shabu|mild  | none   | none      | none       | none     | none      |  none     | none   | none    | none            | none  |none|  none         |    none      |  none      | none |    none      |   none    |   none      |    none    |  none    |     none         |   none  |  none  |   none   |   none              |

    When I click the add button
    Then it should have a '200' response
    And it should have a field 'status' containing 'OK'
    And it should have a field 'message' containing 'Successfully added new patient'


    Scenario: Create patient file - Empty inputs
    Given the following details of patient
    |school_id| fname       | mname  | lname    |age| sex    | department_id| patient_type_id|height | weight | date_of_birth  | civil_status |name_of_guardian|home_address         |smoking|allergies|alcohol |medications_taken|drugs|cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge  |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem  |hepatitis_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness|
    |20130010 |             |Daligdig|          |19 |female  |    1         |     1          | 5 ft  | 45     | August 20 1996 | single       | Corazon Aquino | Dalipuga Iligan City|slight |chicken  |drunkard| paracetamol     |shabu|mild  | none   | none      | none       | none     | none      |  none     | none   | none    | none            | none  |none|  none         |    none      |  none      | none |    none      |   none    |   none      |    none    |  none    |     none         |   none  |  none  |   none   |   none              |

    When I click the add button
    Then it should have a '200' response
    And it should have a field 'status' containing 'ERROR'
    And it should have a field 'message' containing 'Please type correct inputs'
=======
## Created by Sha-el Regencia at 10/05/2016
#Feature: Patient Files
#  # Enter feature description here
#
#  Scenario: Create patient file - All inputs valid
#    Given the following details of patient
#    |school_id| fname       | mname  | lname    |age| sex    | department_id| patient_type_id|height | weight | date_of_birth  | civil_status |name_of_guardian|home_address         |smoking|allergies|alcohol |medications_taken|drugs|cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge  |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem  |hepatitis_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness| is_active |
#    |201300 10| Kristel     |Daligdig|Pabillaran|19 |female  |    1         |     1          | 5 ft  | 45     | August 20 1996 | single       | Corazon Aquino | Dalipuga Iligan City|slight |chicken  |drunkard| paracetamol     |shabu|mild  | none   | none      | none       | none     | none      |  none     | none   | none    | none            | none  |none|  none         |    none      |  none      | none |    none      |   none    |   none      |    none    |  none    |     none         |   none  |  none  |   none   |   none              | true      |
#    When I click the add button
#    Then  it should have a '200' response
#    And   it should have a field 'status' containing 'OK'
#    And   it should have a field 'message' containing 'Successfully added new patient'
>>>>>>> erikka
