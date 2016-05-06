CREATE TABLE Role (
  id       SERIAL8 PRIMARY KEY,
  rolename TEXT
);

CREATE TABLE Userinfo (
  id           SERIAL8 PRIMARY KEY,
  fname        TEXT        NOT NULL,
  mname        TEXT        NOT NULL,
  lname        TEXT        NOT NULL,
  email        TEXT        NOT NULL,
  username     TEXT UNIQUE NOT NULL,
  password     TEXT        NOT NULL,
  role_id      INT REFERENCES Role (id)
);

CREATE TABLE College ( --Ikai
  id           SERIAL8 PRIMARY KEY,
  college_name TEXT NOT NULL,
  is_active    BOOLEAN DEFAULT TRUE
);

CREATE TABLE Department ( --Ikai
  id              SERIAL8 PRIMARY KEY,
  department_name TEXT NOT NULL,
  college_id      INT REFERENCES College (id),
  is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE Vital_signs ( --Ikai
  id               INT PRIMARY KEY,
  temperature      FLOAT,
  pulse_rate       FLOAT,
  respiration_rate INT,
  blood_pressure   TEXT,
  weight           FLOAT
);

CREATE TABLE Patient_type (
  school_id   SERIAL8 PRIMARY KEY,
  type TEXT
);


CREATE TABLE Patient_info (
  school_id        INT PRIMARY KEY,
  fname            TEXT,
  mname            TEXT,
  lname            TEXT,
  age              INT,
  sex              TEXT,
  department_id    INT REFERENCES Department (id),
  patient_type_id  INT REFERENCES Patient_type (school_id),
  height           TEXT,
  weight           FLOAT,
  date_of_birth    TEXT,
--   date_of_birth    DATE,
  civil_status     TEXT,
  name_of_guardian TEXT,
  home_address     TEXT
);


CREATE TABLE Patient_history (
  school_id        INT PRIMARY KEY,
  smoking          TEXT,
  allergies        TEXT,
  alcohol          TEXT,
  medication_taken TEXT,
  drugs            TEXT
);


CREATE TABLE Pulmonary (
  school_id   INT PRIMARY KEY,
  cough       TEXT,
  dyspnea     TEXT,
  hemoptysis  TEXT,
  tb_exposure TEXT
);

CREATE TABLE Gut (
  school_id        INT PRIMARY KEY,
  frequency        TEXT,
  flank_plan       TEXT,
  discharge        TEXT,
  dysuria          TEXT,
  nocturia         TEXT,
  dec_urine_amount TEXT
);

CREATE TABLE Illness (
  school_id     INT PRIMARY KEY,
  asthma        TEXT,
  ptb           TEXT,
  heart_problem TEXT,
  hepatitis_a_b TEXT,
  chicken_pox   TEXT,
  mumps         TEXT,
  typhoid_fever TEXT
);

CREATE TABLE Cardiac (
  school_id         INT PRIMARY KEY,
  chest_pain        TEXT,
  palpitations      TEXT,
  pedal_edema       TEXT,
  orthopnea         TEXT,
  nocturnal_dyspnea TEXT
);

CREATE TABLE Neurologic (
  school_id             INT UNIQUE PRIMARY KEY,
  headache              TEXT,
  seizure               TEXT,
  dizziness             TEXT,
  loss_of_consciousness TEXT
);

CREATE TABLE Patient (
  school_id INT REFERENCES Patient_info (school_id) PRIMARY KEY,
  personal_history_id INT REFERENCES Patient_history(school_id),
  pulmonary_id     INT REFERENCES Pulmonary (school_id),
  gut_id           INT REFERENCES Gut (school_id),
  illness_id       INT REFERENCES Illness (school_id),
  cardiac_id       INT REFERENCES Cardiac (school_id),
  neurologic_id    INT REFERENCES Neurologic (school_id),
  is_active        BOOLEAN DEFAULT TRUE
);

CREATE TABLE Assessment ( --Ikai
  id                      INT PRIMARY KEY,
  assessment_date         TIMESTAMP DEFAULT 'now',
  school_id               INT REFERENCES Patient (school_id),
  vital_signsID           INT REFERENCES Vital_signs (id),
  chiefcomplaint          TEXT,
  historyofpresentillness TEXT,
  medicationstaken        TEXT,
  diagnosis               TEXT,
  recommendation          TEXT,
  attendingphysician      INT REFERENCES Userinfo (id),
  is_done                 BOOLEAN  DEFAULT FALSE
);