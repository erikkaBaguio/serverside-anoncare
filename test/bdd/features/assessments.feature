# Created by irika-pc at 5/9/2016
Feature: Assessment
  As a nurse, I want to assess the patient.

  #SUNNY CASE
  Scenario: Create assessment successfully.
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20000000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |3                   |

      And   school id '20130000' exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'OK'
      And   it should have a field 'message' containing 'OK'


  #RAINY CASES
  Scenario: Create assessment - school id does not exists
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |00000000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |3                  |

      And   school id '00000000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'School ID does not exist.'


  Scenario: Create assessment - chief complaint field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |90/70          |48.5   |                   |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - history of present illness field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |                           |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - medications taken field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |                  |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - diagnosis field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |               |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - recommendation field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |                    |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - age field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |    |37.9        |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - temperature field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |            |80         |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - pulse rate field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |           |19               |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - respiration rate field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |                 |90/70          |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - blood pressure field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |               |48.5   |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'


  Scenario: Create assessment - weight field is empty
      Given the nurse have the following assessment details:
                |school_id |age |temperature |pulse_rate |respiration_rate |blood_pressure |weight |chief_complaint    |history_of_present_illness |medications_taken |diagnosis      |recommendation      |attending_physician |
                |20130000  |19  |37.9        |80         |19               |90/70          |       |testchiefcomplaint |test history               |test medication   |test diagnosis |test recommendation |1                   |

      And   school id '20130000' does not exists
      When  the nurse clicks the send button
      Then  it should have a '200' response
      And   it should have a field 'status' containing 'FAILED'
      And   it should have a field 'message' containing 'Please fill the required fields'