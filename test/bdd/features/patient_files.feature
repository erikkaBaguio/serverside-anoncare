#Feature: Patient Files
#  # Enter feature description here
#
#
##SUNNY CASES
#  Scenario: Create patient file - All inputs valid
#      Given the following details of patient
#            |school_id| fname       | mname  | lname    |age| sex    | department_id| patient_type_id|height | weight | date_of_birth  | civil_status |name_of_guardian|home_address         |smoking|allergies|alcohol |medications_taken|drugs|cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge  |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem  |hepatitis_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness|
#            |20133074 | Kristel     |Daligdig|Pabillaran|19 |female  |    1         |     1          | 5 ft  | 45     | August 20 1996 | single       | Corazon Aquino | Dalipuga Iligan City|slight |chicken  |drunkard| paracetamol     |shabu|mild  | nothing| nothing   | nothing    | nothing  | planking  |  lbm      |diarrhea|nocturnal| uti             | hubak |tb  |  heart broken |yellow fellow |  fried     |myhump|    typhoon   |   haha    |   bugbug    |bike pedal? |  otrho   |     nocnoc       |   haha  |  haha  |   haha   |   ahah              |
#
#
#      When  I click the add button
#      Then  it should have a '200' response
#      And   it should have a field 'status' containing 'OK'
#      And   it should have a field 'message' containing 'Successfully added new patient'
#
#
#  Scenario: View patient file
#      Given the patient file with school id '20130000'
#      And   school id '20130000' exists
#      When  the doctor click view patient file
#      Then  it should have a '200' response
#      And   it should have a field 'status' containing 'OK'
#      And   it should have a field 'message' containing 'OK'
#      And 	the following details will be returned
#            |school_id |fname |mname |lname |age |sex   |dept_id |ptnt_id |height |weight |date_of_birth |civil_status |guardian |home_addr  |smoking |allergies |alcohol |medications_taken |drugs |cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem |hepa_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness |
#            |20130000  |ftest1|mtest1|ltest1|20  |Male  |2       |1       |6      |55     |August 20 1996|test         |test     |test       |test    |test      |test    |test              |test  |test  |test    |test       |test        |test      |test       |test      |test    |test     |test             |test   |test|test          |test     |test        |test  |test          |test       |test         |test        |test      |test              |test      |test    |test      |test                  |
#
#
#
##RAINY CASES
#  Scenario: Create patient file - Empty inputs
#      Given the following details of patient
#            |school_id| fname       | mname  | lname    |age| sex    | department_id| patient_type_id|height | weight | date_of_birth  | civil_status |name_of_guardian|home_address         |smoking|allergies|alcohol |medications_taken|drugs|cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge  |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem  |hepatitis_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness|
#            |201300780 |             |Daligdig|          |19 |female  |    1         |     1          | 5 ft  | 45     | August 20 1996 | single       | Corazon Aquino | Dalipuga Iligan City|slight |chicken  |drunkard| paracetamol     |shabu|mild  | none   | none      | none       | none     | none      |  none     | none   | none    | none            | none  |none|  none         |    none      |  none      | none |    none      |   none    |   none      |    none    |  none    |     none         |   none  |  none  |   none   |   none              |
#
#      When  I click the add button
#      Then  it should have a '200' response
#      And   it should have a field 'status' containing 'ERROR'
#      And   it should have a field 'message' containing 'Please type correct inputs'
#
#
#  Scenario: View patient file - id does not exists
#      Given the patient file with school id '00000000'
#      And   school id '20000000' does not exists
#      When  the doctor click view patient file
#      Then  it should have a '200' response
#      And   it should have a field 'status' containing 'FAILED'
#
#
#    Scenario: Create patient file - school_id already exists
#      Given the following details of patient
#            |school_id| fname       | mname  | lname    |age| sex    | department_id| patient_type_id|height | weight | date_of_birth  | civil_status |name_of_guardian|home_address         |smoking|allergies|alcohol |medications_taken|drugs|cough |dyspnea |hemoptysis |tb_exposure |frequency |flank_plan |discharge  |dysuria |nocturia |dec_urine_amount |asthma |ptb |heart_problem  |hepatitis_a_b |chicken_pox |mumps |typhoid_fever |chest_pain |palpitations |pedal_edema |orthopnea |nocturnal_dyspnea |headache |seizure |dizziness |loss_of_consciousness|
#            |20133074 | Kristel     |Daligdig|Pabillaran|19 |female  |    1         |     1          | 5 ft  | 45     | August 20 1996 | single       | Corazon Aquino | Dalipuga Iligan City|slight |chicken  |drunkard| paracetamol     |shabu|mild  | nothing| nothing   | nothing    | nothing  | planking  |  lbm      |diarrhea|nocturnal| uti             | hubak |tb  |  heart broken |yellow fellow |  fried     |myhump|    typhoon   |   haha    |   bugbug    |bike pedal? |  otrho   |     nocnoc       |   haha  |  haha  |   haha   |   ahah              |
#
#
#      When  I click the add button
#      Then  it should have a '200' response
#      And   it should have a field 'status' containing 'FAILED'
#      And   it should have a field 'message' containing 'School ID already exists'
#
