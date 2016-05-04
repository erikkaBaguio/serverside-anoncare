CREATE TABLE Personal_info (
  school_id        SERIAL8 PRIMARY KEY,
  fname            TEXT,
  mname            TEXT,
  lname            TEXT,
  age              INT,
  sex              TEXT,
  department_id    INT REFERENCES Department (id),
  patient_type_id  INT REFERENCES Patient_type (school_id),
  height           TEXT,
  weight           FLOAT,
  date_of_birth    DATE,
  civil_status     TEXT,  
  name_of_guardian TEXT,
  home_address     TEXT
);

CREATE TABLE Personal_history (
  school_id        SERIAL8 PRIMARY KEY,
  smoking          TEXT,
  allergies        TEXT,
  alcohol          TEXT,
  medication_taken TEXT,
  drugs            TEXT
);


CREATE TABLE Pulmonary (
  school_id   SERIAL8 PRIMARY KEY,
  cough       TEXT,
  dyspnea     TEXT,
  hemoptysis  TEXT,
  tb_exposure TEXT
);

CREATE TABLE Gut (
  school_id        SERIAL8 PRIMARY KEY,
  frequency        TEXT,
  flank_plan       TEXT,
  discharge        TEXT,
  dysuria          TEXT,
  nocturia         TEXT,
  dec_urine_amount TEXT
);

CREATE TABLE Illness (
  school_id     SERIAL8 PRIMARY KEY,
  asthma        TEXT,
  ptb           TEXT,
  heart_problem TEXT,
  hepatitis_a_b TEXT,
  chicken_pox   TEXT,
  mumps         TEXT,
  typhoid_fever TEXT
);

CREATE TABLE Cardiac (
  school_id         SERIAL8 PRIMARY KEY,
  chest_pain        TEXT,
  palpitations      TEXT,
  pedal_edema       TEXT,
  orthopnea         TEXT,
  nocturnal_dyspnea TEXT
);

CREATE TABLE Neurologic (
  school_id             SERIAL8 UNIQUE PRIMARY KEY,
  headache              TEXT,
  seizure               TEXT,
  dizziness             TEXT,
  loss_of_consciousness TEXT
);

CREATE TABLE Patient (
  school_id        SERIAL8 PRIMARY KEY,
  personal_info_id INT REFERENCES Personal_info (school_id),
  personal_history_id INT REFERENCES Personal_history(school_id),
  pulmonary_id     INT REFERENCES Pulmonary (school_id),
  gut_id           INT REFERENCES Gut (school_id),
  illness_id       INT REFERENCES Illness (school_id),
  cardiac_id       INT REFERENCES Cardiac (school_id),
  neurologic_id    INT REFERENCES Neurologic (school_id),
  is_active        BOOLEAN DEFAULT TRUE
);

