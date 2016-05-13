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

-------------------------------------------------------------------------------------------------------------------------
Create or replace function show_user_id(in par_id int, out text, out text, out text, out text, out text, out int) RETURNS SETOF RECORD AS
$$
SELECT
  fname,
  mname,
  lname,
  email,
  username,
  role_id
FROM Userinfo
WHERE par_id = id;
$$
LANGUAGE 'sql';


--this will show the user information via username parameter
create or replace function show_user_username(in par_username text, out text, out text, out text, out text, out text, out int) returns setof record as
  $$
    select fname, mname, lname, email, username, role_id from Userinfo where username = par_username;
  $$
  language 'sql';


create or replace function show_user_email(in par_email text, out text, out text, out text, out text, out text, out int) returns setof record as
  $$
    select fname, mname, lname, email, username, role_id from Userinfo where email = par_email;
  $$
  language 'sql';


create or replace function check_username_password(in par_username text, in par_password text) returns text as
  $$  declare local_response text;
    begin
      select into local_response username from Userinfo where username = par_username and password = par_password;

      if local_response isnull then
        local_response = 'FAILED';
      else
        local_response = 'OK';
      end if;

      return local_response;
    end;
  $$
  language 'plpgsql';

--------------------------------------------------------------- USER -----------------------------------------------------------
-- this will return set of users that match or slightly match your search
--source: http://www.tutorialspoint.com/postgresql/postgresql_like_clause.htm
--source on concationation in postgres: http://www.postgresql.org/docs/9.1/static/functions-string.html
create or replace function search_user(in par_search text, out text, out text, out text, out text, out text, out int) returns setof record as
  $$
      select fname, mname, lname, email, username, role_id from Userinfo where fname like '%'|| par_search || '%'
        or mname like '%'|| par_search || '%'
        or lname like '%'|| par_search || '%'
        or email like '%'|| par_search || '%';
  $$
  language 'sql';


-- Check if user exists via username
-- return 'OK' if user does not exist
-- Otherwise, 'EXISTED'.
create or replace function check_username(in par_username text) returns text as
  $$
    declare
      local_response text;
      local_id bigint;
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
  $$
  declare local_response text;
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


-- [GET] Retrieve all users
-- select show_all_users();
create or replace function show_all_users(out bigint,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out int)
  returns setOf record as
$$
  select id, fname, mname, lname, username, email, role_id
  from Userinfo
$$
  language 'sql';
------------------------------------------------------------- END USER -------------------------------------------------------------


-------------------------------------------------------- Patient File -----------------------------------------------------
--[POST] Create patient file
create or replace function new_store_patient(in par_school_id int, in par_fname text, in par_mname text, in par_lname text,
                                              in par_age int, in par_sex text, in par_dept_id int, in par_ptnt_type_id int,
                                              in par_height text, in par_weight float, in par_date_of_birth text,
--                                               in par_height text, in par_weight float, in par_date_of_birth date,
                                              in par_civil_status text, in par_name_of_gdn text, in par_home_addr text) returns text as
$$
declare local_response text;
    begin

      insert into
       Patient_info(school_id, fname, mname, lname, age, sex,
                    department_id, patient_type_id, height, weight,
                    date_of_birth, civil_status, name_of_guardian, home_address)
      values
        (par_school_id, par_fname, par_mname, par_lname, par_age, par_sex,
         par_dept_id, par_ptnt_type_id, par_height, par_weight, par_date_of_birth,
          par_civil_status, par_name_of_gdn, par_home_addr);
      local_response = 'OK';
      return local_response;

    end;

$$
language 'plpgsql';


create or replace function new_patient_history(in par_school_id int, in par_smoking text, in par_allergies text,
                                                in par_alcohol text, in par_meds text, in par_drugs text) returns text as

$$
declare local_response text;
    begin

      insert into
       Patient_history(school_id, smoking, allergies, alcohol, medication_taken, drugs)
      values
        (par_school_id, par_smoking, par_allergies, par_alcohol, par_meds, par_drugs);
      local_response = 'OK';
      return local_response;

    end;
$$

language 'plpgsql';

create or replace function new_pulmonary(in par_school_id int, in par_cough text, in par_dyspnea text, in par_hemop text, in par_tb_exposure text) returns text as

$$
declare local_response text;
    begin

      insert into
       Pulmonary(school_id, cough, dyspnea, hemoptysis, tb_exposure)
      values
        (par_school_id, par_cough, par_dyspnea, par_hemop, par_tb_exposure);
      local_response = 'OK';
      return local_response;

    end;
$$

language 'plpgsql';


create or replace function new_gut(in par_school_id int, in par_freq text, in par_flank_plan text, in par_discharge text,
                                    in par_dysuria text, in par_nocturia text, in par_dec_urine_amt text) returns text as

$$
declare local_response text;
    begin

      insert into
       Gut(school_id, frequency, flank_plan, discharge, dysuria, nocturia, dec_urine_amount)
      values
        (par_school_id, par_freq, par_flank_plan, par_discharge, par_dysuria, par_nocturia, par_dec_urine_amt);
      local_response = 'OK';
      return local_response;

    end;
$$

language 'plpgsql';


create or replace function new_illness(in par_school_id int, in par_asthma text, in par_ptb text, in par_heart_prob text,
                                        in par_hepa_a_b text, in par_chicken_pox text, in par_mumps text, in par_typ_fever text) returns text as

$$
declare local_response text;
    begin

      insert into
       Illness(school_id, asthma, ptb, heart_problem, hepatitis_a_b, chicken_pox, mumps, typhoid_fever)
      values
        (par_school_id, par_asthma, par_ptb, par_heart_prob, par_hepa_a_b, par_chicken_pox, par_mumps, par_typ_fever);
      local_response = 'OK';
      return local_response;

    end;
$$

language 'plpgsql';


create or replace function new_cardiac(in par_school_id int, in par_chest_pain text, in par_palp text, in par_pedal_edema text,
                                        in par_orthopnea text, in par_noct_dysp text) returns text as

$$
declare local_response text;
    begin

      insert into
       Cardiac(school_id, chest_pain, palpitations, pedal_edema, orthopnea, nocturnal_dyspnea)
      values
        (par_school_id, par_chest_pain, par_palp, par_pedal_edema, par_orthopnea, par_noct_dysp);
      local_response = 'OK';
      return local_response;

    end;
$$

language 'plpgsql';


create or replace function new_neurologic(in par_school_id int, in par_headache text, in par_seizure text, in par_dizziness text,
                                          in par_loss_of_consciousness text) returns text as

$$
declare local_response text;
    begin

      insert into
       Neurologic(school_id, headache, seizure, dizziness, loss_of_consciousness)
      values
        (par_school_id, par_headache, par_seizure, par_dizziness, par_loss_of_consciousness );
      local_response = 'OK';
      return local_response;

    end;
$$

language 'plpgsql';


--Check if school id exists or not
--select school_id_exists(20130000);
create or replace function school_id_exists(in par_school_id int) returns text as

$$
  declare
    loc_id text;

  begin
    select into loc_id par_school_id from Patient_info where school_id = par_school_id;
    if loc_id isnull then
      loc_id = FALSE;
    else
      loc_id = TRUE;

    end if;

    return loc_id;

  end;

$$

language 'plpgsql';


--[GET] Retrieve specific patient info
--select show_patient_info(20130000);
create or replace function show_patient_info(in par_school_id int,
                                             out int,
                                             out text,
                                             out text,
                                             out text,
                                             out int,
                                             out text,
                                             out int,
                                             out int,
                                             out text,
                                             out float,
                                             out text,
                                             out text,
                                             out text,
                                             out text)
  returns setof record as
  $$
    select *
    from Patient_info
    where school_id = par_school_id;
  $$
    language 'sql';


--[GET] Retrieve specific patient history
--select show_patient_history(20130000);
create or replace function show_patient_history(in par_school_id int,
                                                out int,
                                                out text,
                                                out text,
                                                out text,
                                                out text,
                                                out text)
    returns setof record as
$$
  select *
  from Patient_history
  where school_id = par_school_id;
$$
    language 'sql';


--[GET] Retrieve pulmonary data of a patient
--select show_pulmonary(20130000);
create or replace function show_pulmonary(in par_school_id int,
                                          out int,
                                          out text,
                                          out text,
                                          out text,
                                          out text)
    returns setof record as
$$
  select *
  from Pulmonary
  where school_id = par_school_id;
$$
    language 'sql';


--[GET] Retrieve gut data of a patient
--select show_gut(20130000);
create or replace function show_gut(in par_school_id int,
                                          out int,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text)
    returns setof record as
$$
  select *
  from Gut
  where school_id = par_school_id;
$$
    language 'sql';


--[GET] Retrieve illness data of a patient
--select show_illness(20130000);
create or replace function show_illness(in par_school_id int,
                                          out int,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text)
    returns setof record as
$$
  select *
  from Illness
  where school_id = par_school_id;
$$
    language 'sql';


--[GET] Retrieve cardiac data of a patient
--select show_cardiac(20130000);
create or replace function show_cardiac(in par_school_id int,
                                          out int,
                                          out text,
                                          out text,
                                          out text,
                                          out text,
                                          out text)
    returns setof record as
$$
  select *
  from Cardiac
  where school_id = par_school_id;
$$
    language 'sql';


--[GET] Retrieve neurologic data of a patient
--select show_neurologic(20130000);
create or replace function show_neurologic(in par_school_id int,
                                          out int,
                                          out text,
                                          out text,
                                          out text,
                                          out text)
    returns setof record as
$$
  select *
  from Neurologic
  where school_id = par_school_id;
$$
    language 'sql';




-----------------------------------------------------END OF PATIENT FILE --------------------------------------------------


------------------------------------------------------------ ASSESSMENTS -----------------------------------------------------------
create or replace function show_assessment_by_id(in par_assessment_id bigint,
                                                                 out bigint,
											                     out timestamp,
											                     out int,
											                     out int,
											                     out int,
											                     out text,
											                     out text,
											                     out text,
											                     out text,
                                                                 out text,
                                                                 out int,
											                     out boolean) returns setof record as
    $$
        update assessment set is_read = TRUE;
        select * from assessment where id = par_assessment_id;
    $$
    language 'sql';


-- [POST] Insert vital signs data of a patient
-- select update_vitalSigns(3,37.1, 80, 19, '90/70', 48)
create or replace function update_vitalSigns(in par_id int,
                                             in par_temperature float,
                                             in par_pulse_rate int,
                                             in par_respiration_rate int,
                                             in par_blood_pressure text,
                                             in par_weight float)
  returns text as
$$
  declare
    local_response text;
  begin

    update Vital_signs
    set
      id = par_id,
      temperature = par_temperature,
      pulse_rate = par_pulse_rate,
      respiration_rate = par_respiration_rate,
      blood_pressure = par_blood_pressure,
      weight = par_weight
    where
      id = par_id;

    local_response = 'OK';
    return local_response;

  end;
$$
  language 'plpgsql';


-- [POST] Insert assessment of patient
--select store_assessment(20130000,19,'cp','hpi','mt','d','r',1);
create or replace function store_assessment(in par_schoolID                 INT,
                                            in par_age                      INT,
                                            in par_chiefcomplaint           TEXT,
                                            in par_historyofpresentillness  TEXT,
                                            in par_medicationstaken         TEXT,
                                            in par_diagnosis                TEXT,
                                            in par_recommendation           TEXT,
                                            in par_attendingphysician       INT)
  returns bigint as
  $$
    declare
      local_response bigint;
    begin

      insert into Assessment (school_id, age, chiefcomplaint, historyofpresentillness, medicationstaken, diagnosis, recommendation, attendingphysician)
      values (par_schoolID, par_age, par_chiefcomplaint, par_historyofpresentillness, par_medicationstaken, par_diagnosis, par_recommendation, par_attendingphysician);

      SELECT INTO local_response currval(pg_get_serial_sequence('Assessment','id'));

      return local_response;

    end;
  $$
    language 'plpgsql';


--[GET] Retrieve all assessments of a specific patient
--select show_assessment(20130000);
create or replace function show_assessment(in par_schoolID int,
                                           out bigint,
											                     out timestamp,
											                     out int,
											                     out int,
											                     out int,
											                     out text,
											                     out text,
											                     out text,
											                     out text,
											                     out text,
											                     out int,
											                     out boolean,
											                     out float,
											                     out int,
											                     out int,
											                     out text,
											                     out float,
											                     out text,
											                     out text)
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
  WHERE Assessment.school_id = par_schoolID
  ORDER BY id DESC;

$$
  LANGUAGE 'sql';


--[GET] Retrieve all assessments of a specific patient
--select show_assessment(20130000,12);
create or replace function show_assessment_id(IN par_schoolID INT,
                                              IN par_assessment_id INT,
                                              OUT BIGINT,
                                              OUT TIMESTAMP,
                                              OUT INT,
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
                                              OUT INT,
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
  WHERE Assessment.school_id = par_schoolID;

$$
  LANGUAGE 'sql';


--[GET] Retrieve all doctors in userinfo table
--select show_all_doctors();
create or replace function show_all_doctors(out bigint,
                                            out text,
                                            out text,
                                            out text)
  returns setof record as
$$
  select id, fname, mname, lname
  from Userinfo
  where role_id = 2;
$$
  language 'sql';


--[PUT] Update assessment of patient
--select update_assessment(1,20130000, 'medication1f', 'diagnosis11f','recommendation11', 1);
create or replace function update_assessment(in par_id                 bigint,
                                             in par_schoolid           int,
                                             in par_diagnosis          text,
                                             in par_recommendation     text,
                                             in par_attendingphysician int)
  returns text as
$$
declare
  loc_res text;
begin

  update Assessment
  set
    diagnosis          = par_diagnosis,
    recommendation     = par_recommendation,
    attendingphysician = par_attendingphysician
  where id = par_id
  and school_id = par_schoolid;

  loc_res = 'OK';
  return loc_res;

end;
$$
  language 'plpgsql';

------------------------------------------------------------------------------------------------------------------------------------

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
