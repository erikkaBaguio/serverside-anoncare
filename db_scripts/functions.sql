--[POST] Insert role
--select store_role('admin');
CREATE OR REPLACE FUNCTION store_role(par_rolename TEXT)
  RETURNS TEXT AS
$$
DECLARE
  loc_name TEXT;
  loc_res  TEXT;
BEGIN

  SELECT INTO loc_name rolename
  FROM Role
  WHERE rolename = par_rolename;

  IF loc_name ISNULL
  THEN
    INSERT INTO Role (rolename) VALUES (par_rolename);
    loc_res = 'OK';

  ELSE
    loc_res = 'EXISTED';

  END IF;
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';


select store_role('admin');
select store_role('doctor');
select store_role('nurse');

--------------------------------------------------------------- USER ---------------------------------------------------------------
-- Check if user exists via username
-- return 'OK' if user does not exist
-- Otherwise, 'EXISTED'.
create or replace function check_username(in par_username text) returns text as
  $$ declare local_response text; local_id bigint;
    begin

      select into local_id id from Userinfo where username = par_username;

      if local_id isnull then
        local_response := 'OK';
      else
        local_response := 'EXISTED';

      end if;

      return local_response;

    end;
  $$
  language 'plpgsql';


-- Check if user exists via email
-- return 'OK' if user does not exist
-- Otherwise, 'EXISTED'.
create or replace function check_mail(in par_mail text) returns text as
  $$ declare local_response text; local_id bigint;
    begin

      select into local_id id from Userinfo where email = par_mail;

      if local_id isnull then
        local_response := 'OK';
      else
        local_response := 'EXISTED';

      end if;

      return local_response;

    end;
  $$
  language 'plpgsql';


-- [POST] Insert user
-- select store_user('remarc', 'espinosa', 'balisi', 'apps-user', 'admin', 'remarc.balisi@gmail.com', 2);
create or replace function store_user(in par_fname text, in par_mname text, in par_lname text, in par_username text, in par_password text, in par_email text, in par_role_id int8) returns text as
  $$ declare local_response text;
    begin

      insert into Userinfo(fname, mname, lname, username, password, email, role_id) values (par_fname, par_mname, par_lname, par_username, par_password, par_email, par_role_id);
      local_response = 'OK';
      return local_response;

    end;
  $$
  language 'plpgsql';


-- [GET] Get password of a specific user
--select get_password('apps-user');
create or replace function get_password(par_username text) returns text as
$$
  declare
    loc_password text;
  begin
     select into loc_password password
     from Userinfo
     where username = par_username;

     if loc_password isnull then
       loc_password = 'null';
     end if;
     return loc_password;
 end;
$$
 language 'plpgsql';

------------------------------------------------------------- END USER -------------------------------------------------------------


-------------------------------------------------------- Patient File -----------------------------------------------------
--[POST] Create patient file
--select * from newpatient(1, 'Mary Grace', 'Pasco', 'Cabolbol', 19 ,'female', 1, 1 , '4ft', 45, 'august 13 1995', 'single', 'Juan Manalo', 'iligan city', 'mild', 'none' , 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none', TRUE)
CREATE OR REPLACE FUNCTION newpatient(par_id                    INT, par_fname TEXT, par_mname TEXT, par_lname TEXT,
                                      par_age                   INT, par_sex TEXT,
                                      par_department_id         INT, par_patient_type_id INT, par_height TEXT,
                                      par_weight                FLOAT, par_date_of_birth TEXT,
                                      par_civil_status          TEXT, par_name_of_guardian TEXT, par_home_address TEXT,
                                      par_cough                 TEXT, par_dyspnea TEXT,
                                      par_hemoptysis            TEXT, par_tb_exposure TEXT, par_frequency TEXT,
                                      par_flank_plan            TEXT, par_discharge TEXT,
                                      par_dysuria               TEXT, par_nocturia TEXT, par_dec_urine_amount TEXT,
                                      par_asthma                TEXT, par_ptb TEXT,
                                      par_heart_problem         TEXT, par_hepatitis_a_b TEXT, par_chicken_pox TEXT,
                                      par_mumps                 TEXT, par_typhoid_fever TEXT,
                                      par_chest_pain            TEXT, par_palpitations TEXT, par_pedal_edema TEXT,
                                      par_orthopnea             TEXT, par_nocturnal_dyspnea TEXT,
                                      par_headache              TEXT, par_seizure TEXT, par_dizziness TEXT,
                                      par_loss_of_consciousness TEXT, par_is_active BOOLEAN)
  RETURNS TEXT AS
$$
DECLARE
  loc_fname TEXT;
  loc_mname TEXT;
  loc_lname TEXT;
  loc_res   TEXT;
  loc_id1   INT;
  loc_id2   INT;
  loc_id3   INT;
  loc_id4   INT;
  loc_id5   INT;
  loc_id6   INT;
  loc_id7   INT;

BEGIN

  SELECT INTO loc_id1 id
  FROM Personal_info
  WHERE id = par_id;
  SELECT INTO loc_id2 id
  FROM Pulmonary
  WHERE id = par_id;
  SELECT INTO loc_id3 id
  FROM Gut
  WHERE id = par_id;
  SELECT INTO loc_id4 id
  FROM Illness
  WHERE id = par_id;
  SELECT INTO loc_id5 id
  FROM Cardiac
  WHERE id = par_id;
  SELECT INTO loc_id6 id
  FROM Neurologic
  WHERE id = par_id;
  SELECT INTO loc_id7 id
  FROM Patient
  WHERE id = par_id;
  SELECT INTO loc_fname fname
  FROM Patient
  WHERE fname = par_fname AND mname = par_mname AND lname = par_lname;
  IF par_id ISNULL OR par_fname = '' OR par_mname = '' OR par_lname = '' OR par_age ISNULL OR par_sex = '' OR
     par_department_id ISNULL OR
     par_patient_type_id ISNULL OR par_height ISNULL OR par_weight ISNULL OR par_date_of_birth = '' OR
     par_civil_status = '' OR
     par_name_of_guardian = '' OR par_home_address = '' OR par_cough = '' OR par_dyspnea = '' OR par_hemoptysis = '' OR
     par_tb_exposure = '' OR par_frequency = '' OR par_flank_plan = '' OR par_discharge = '' OR par_dysuria = '' OR
     par_nocturia = '' OR par_dec_urine_amount = '' OR par_asthma = '' OR par_ptb = '' OR par_heart_problem = '' OR
     par_hepatitis_a_b = '' OR par_chicken_pox = '' OR par_mumps = '' OR par_typhoid_fever = '' OR par_chest_pain = ''
     OR
     par_palpitations = '' OR par_pedal_edema = '' OR par_orthopnea = '' OR par_nocturnal_dyspnea = '' OR
     par_headache = '' OR
     par_seizure = '' OR par_dizziness = '' OR par_loss_of_consciousness = ''
  THEN
    loc_res = 'Please fill up the required data';
  ELSIF
    loc_fname ISNULL AND loc_id1 ISNULL AND loc_id2 ISNULL AND loc_id3 ISNULL AND loc_id4 ISNULL AND loc_id5 ISNULL AND
    loc_id6 ISNULL AND loc_id7 ISNULL
    THEN
      INSERT INTO Personal_info (id, height, weight, date_of_birth, civil_status, name_of_guardian, home_address)
      VALUES
        (par_id, par_height, par_weight, par_date_of_birth, par_civil_status, par_name_of_guardian, par_home_address);
      INSERT INTO Pulmonary (id, cough, dyspnea, hemoptysis, tb_exposure)
      VALUES (par_id, par_cough, par_dyspnea, par_hemoptysis, par_tb_exposure);
      INSERT INTO Gut (id, frequency, flank_plan, discharge, dysuria, nocturia, dec_urine_amount)
      VALUES (par_id, par_frequency, par_flank_plan, par_discharge, par_dysuria, par_nocturia, par_dec_urine_amount);
      INSERT INTO Illness (id, asthma, ptb, heart_problem, hepatitis_a_b, chicken_pox, mumps, typhoid_fever)
      VALUES (par_id, par_asthma, par_ptb, par_heart_problem, par_hepatitis_a_b, par_chicken_pox, par_mumps,
              par_typhoid_fever);
      INSERT INTO Cardiac (id, chest_pain, palpitations, pedal_edema, orthopnea, nocturnal_dyspnea)
      VALUES (par_id, par_chest_pain, par_palpitations, par_pedal_edema, par_orthopnea, par_nocturnal_dyspnea);
      INSERT INTO Neurologic (id, headache, seizure, dizziness, loss_of_consciousness)
      VALUES (par_id, par_headache, par_seizure, par_dizziness, par_loss_of_consciousness);
      INSERT INTO Patient (id, fname, mname, lname, age, sex, department_id, patient_type_id, personal_info_id, pulmonary_id, gut_id, illness_id, cardiac_id, neurologic_id, is_active)
      VALUES (par_id, par_fname, par_mname, par_lname, par_age, par_sex, par_department_id, par_patient_type_id, par_id,
                      par_id, par_id, par_id, par_id, par_id, par_is_active);

      loc_res = 'OK';
  ELSE
    loc_res = 'Patient already EXISTED';
  END IF;
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';

--[GET] patient file
--select * from get_patientfileId(1);
CREATE OR REPLACE FUNCTION get_patientfileId(IN par_id INT, OUT TEXT, OUT TEXT, OUT TEXT, OUT INT, OUT TEXT,
                                             OUT       TEXT, OUT FLOAT, OUT TEXT, OUT TEXT, OUT TEXT,
                                             OUT       TEXT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT,
                                             OUT       TEXT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT,
                                             OUT       TEXT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT,
                                             OUT       TEXT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT,
                                             OUT       TEXT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT,
                                             OUT       TEXT, OUT TEXT)
  RETURNS SETOF RECORD AS
$$
SELECT
  Patient.fname,
  Patient.mname,
  Patient.lname,
  Patient.age,
  Patient.sex,
  Personal_info.height,
  Personal_info.weight,
  Personal_info.date_of_birth,
  Personal_info.civil_status,
  Personal_info.name_of_guardian,
  Personal_info.home_address,
  Pulmonary.cough,
  Pulmonary.dyspnea,
  Pulmonary.hemoptysis,
  Pulmonary.tb_exposure,
  Gut.frequency,
  Gut.flank_plan,
  Gut.discharge,
  Gut.dysuria,
  Gut.nocturia,
  Gut.dec_urine_amount,
  Illness.asthma,
  Illness.ptb,
  Illness.heart_problem,
  Illness.hepatitis_a_b,
  Illness.chicken_pox,
  Illness.mumps,
  Illness.typhoid_fever,
  Cardiac.chest_pain,
  Cardiac.palpitations,
  Cardiac.pedal_edema,
  Cardiac.orthopnea,
  Cardiac.nocturnal_dyspnea,
  Neurologic.headache,
  Neurologic.seizure,
  Neurologic.dizziness,
  Neurologic.loss_of_consciousness
FROM Patient, Personal_info, Pulmonary, Gut, Illness, Cardiac, Neurologic
WHERE Patient.id = par_id AND Personal_info.id = Patient.personal_info_id AND Pulmonary.id = Patient.pulmonary_id AND
      Gut.id = Patient.gut_id AND Illness.id = Patient.illness_id AND Cardiac.id = Patient.cardiac_id AND
      Neurologic.id = Patient.neurologic_id;
$$
LANGUAGE 'sql';

--[GET] Retrieve the type of patient.
--select getpatienttypeID(1);
CREATE OR REPLACE FUNCTION getpatienttypeID(IN par_id INT, OUT TEXT)
  RETURNS TEXT AS
$$
SELECT type
FROM Patient_type
WHERE id = par_id;
$$
LANGUAGE 'sql';

-----------------------------------------------------END of Patient File --------------------------------------------------

-------------------------------------------------------- Assessment -------------------------------------------------------
-- [POST] Create new assessment
--select new_assessment(1,20130000, 37.1, 80, 19, '90/70', 48, 'complaint', 'history', 'medication1', 'diagnosis1','recommendation1', 1);
--select new_assessment(2,20130001, 36.4, 70, 19, '100/80', 45, 'complaint', 'history', 'medication1', 'diagnosis1','recommendation1', 1);
CREATE OR REPLACE FUNCTION new_assessment(IN par_id                       INT,
                                          IN par_schoolID                 INT,
                                          IN par_temperature              FLOAT,
                                          IN par_pulse_rate               FLOAT,
                                          IN par_respiration_rate         INT,
                                          IN par_blood_pressure           TEXT,
                                          IN par_weight                   FLOAT,
                                          IN par_chiefcomplaint           TEXT,
                                          IN par_historyofpresentillness  TEXT,
                                          IN par_medicationstaken         TEXT,
                                          IN par_diagnosis                TEXT,
                                          IN par_recommendation           TEXT,
                                          IN par_attendingphysician       INT)
  RETURNS TEXT AS
$$
DECLARE
  loc_id1       INT;
  loc_id2       INT;
  loc_res       TEXT;
BEGIN
  SELECT INTO loc_id1 id
  FROM Assessment
  WHERE id = par_id;

  SELECT INTO loc_id2 id
  FROM Vital_signs
  WHERE id = par_id;

  IF loc_id1 ISNULL AND loc_id2 ISNULL
  THEN
    IF par_chiefcomplaint = '' OR
       par_chiefcomplaint ISNULL OR
       par_medicationstaken = '' OR
       par_medicationstaken ISNULL OR
       par_diagnosis = '' OR
       par_diagnosis ISNULL
    THEN
      loc_res = 'PLEASE FILL THE REQUIRE FIELDS';

    ELSE
        INSERT INTO Vital_signs(id, temperature, pulse_rate, respiration_rate, blood_pressure, weight)
        VALUES (par_id,par_temperature, par_pulse_rate, par_respiration_rate, par_blood_pressure, par_weight);

        INSERT INTO Assessment (id,school_id, vital_signsID, chiefcomplaint, historyofpresentillness,
                                medicationstaken, diagnosis, recommendation, attendingphysician)
        VALUES (par_id,par_schoolID, par_id, par_chiefcomplaint, par_historyofpresentillness, par_medicationstaken,
                par_diagnosis, par_recommendation, par_attendingphysician);

        loc_res = 'OK';

    END IF;
  ELSE
      loc_res = 'ID EXISTS';
  END IF;
  RETURN loc_res;

END;
$$
  LANGUAGE 'plpgsql';


--[GET] Retrieve assessment of a specific patient
--select getassessmentID(20130000,1);
CREATE OR REPLACE FUNCTION getassessmentID(IN par_schoolID INT,
                                           IN par_id INT,
                                           OUT INT,
                                           OUT TIMESTAMP,
                                           OUT INT,
                                           OUT INT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT INT,
                                           OUT BOOLEAN,
                                           OUT FLOAT,
                                           OUT FLOAT,
                                           OUT INT,
                                           OUT TEXT,
                                           OUT FLOAT,
                                           OUT TEXT,
                                           OUT TEXT)
  RETURNS SETOF RECORD AS
$$

select Assessment.*,
         Vital_signs.temperature,
         Vital_signs.pulse_rate,
         Vital_signs.respiration_rate,
         Vital_signs.blood_pressure,
         Vital_signs.weight,
         Userinfo.fname,
         Userinfo.lname
  FROM Assessment
  INNER JOIN Vital_signs ON (
    Assessment.vital_signsID = Vital_signs.id
    )
  INNER JOIN Userinfo ON (
    Assessment.attendingphysician = Userinfo.id
    )
  WHERE Assessment.id = par_id
  AND Assessment.school_id = par_schoolID

$$
LANGUAGE 'sql';


-- [GET] Retrieve all assessment of a specific patient
--select getallassessmentID(20130000);
CREATE OR REPLACE FUNCTION getallassessmentID(IN par_schoolID INT,
                                           OUT INT,
                                           OUT TIMESTAMP,
                                           OUT INT,
                                           OUT INT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT TEXT,
                                           OUT INT,
                                           OUT BOOLEAN,
                                           OUT FLOAT,
                                           OUT FLOAT,
                                           OUT INT,
                                           OUT TEXT,
                                           OUT FLOAT,
                                           OUT TEXT,
                                           OUT TEXT)
  RETURNS SETOF RECORD AS
$$
  SELECT Assessment.*,
         Vital_signs.temperature,
         Vital_signs.pulse_rate,
         Vital_signs.respiration_rate,
         Vital_signs.blood_pressure,
         Vital_signs.weight,
         Userinfo.fname,
         Userinfo.lname
  FROM Assessment
  INNER JOIN Vital_signs ON (
    Assessment.vital_signsID = Vital_signs.id
    )
  INNER JOIN Userinfo ON (
    Assessment.attendingphysician = Userinfo.id
    )
  WHERE Assessment.school_id = par_schoolID
  ORDER BY id DESC;

$$
  LANGUAGE 'sql';

--[PUT] Update assessment of patient
--select update_assessment(1,20130000, 'medication1f', 'diagnosis11f','recommendation11', 1);
CREATE OR REPLACE FUNCTION update_assessment(IN par_id                 INT,
                                             IN par_schoolID           TEXT,
                                             IN par_medicationstaken   TEXT,
                                             IN par_diagnosis          TEXT,
                                             IN par_recommendation     TEXT,
                                             IN par_attendingphysician INT)
  RETURNS TEXT AS
$$
DECLARE
  loc_res TEXT;
BEGIN

  UPDATE Assessment
  SET
    diagnosis          = par_diagnosis,
    recommendation     = par_recommendation,
    attendingphysician = par_attendingphysician
  WHERE id = par_id
  AND school_id = par_schoolID;

  loc_res = 'Updated';
  RETURN loc_res;

END;
$$
  LANGUAGE 'plpgsql';

------------------------------------------------------------- QUERIES --------------------------------------------------------------
select store_role('admin');
select store_role('doctor');
select store_role('nurse');

INSERT INTO College VALUES (1, 'SCS');
INSERT INTO College VALUES (2, 'COE');
INSERT INTO College VALUES (3, 'CED');
INSERT INTO College VALUES (4, 'CASS');
INSERT INTO College VALUES (5, 'SET');
INSERT INTO College VALUES (6, 'CBAA');
INSERT INTO College VALUES (7, 'CON');
INSERT INTO College VALUES (8, 'CSM');

INSERT INTO Patient_type VALUES (1, 'Student');
INSERT INTO Patient_type VALUES (2, 'Faculty');
INSERT INTO Patient_type VALUES (3, 'Staff');
INSERT INTO Patient_type VALUES (4, 'Outpatient Department');

INSERT INTO Department VALUES (1, 'Computer Science', 1);
INSERT INTO Department VALUES (2, 'Information Technology', 1);
INSERT INTO Department VALUES (3, 'Information System', 1);
