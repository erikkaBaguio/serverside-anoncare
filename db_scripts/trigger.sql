--this trigger will create a vital sign where id == to the newly created assessment.
--but this will not store any other attribute of vital signs. only the id.
create or replace function create_vital_signs() returns trigger as
	$$
		begin
			if tg_op = 'INSERT' then
				insert into Vital_signs(id)
					values (new.id);
			end if;
			return new;
		end;
	$$
		LANGUAGE 'plpgsql';

create trigger create_vital_sign_ins AFTER insert on Assessment FOR each ROW
EXECUTE PROCEDURE create_vital_signs();

create or replace function update_assessment_trigger() returns trigger as
	$$
		begin
			if tg_op = 'UPDATE' then
				update Assessment set vital_signsID = old.id
				where id = old.id;
			end if;
			return new;
		end;
	$$
		LANGUAGE 'plpgsql';

create trigger update_assessment_trigger_upd AFTER update on Vital_signs FOR each ROW
EXECUTE PROCEDURE update_assessment_trigger();


-- NOTIFICATIONS

-- TRIGGER (notification) - if new assessment is created, automatically create new notification
create or replace function notify() RETURNS trigger AS '
  BEGIN
    IF tg_op = ''INSERT'' THEN
      INSERT INTO Notification (assessment_id, doctor_id, email)
          VALUES (new.id, new.attendingphysician, (select email from userinfo where id=new.attendingphysician));
    RETURN new;
    END IF;
  END
  ' LANGUAGE plpgsql;

create TRIGGER notify_trigger AFTER INSERT ON Assessment FOR each ROW
EXECUTE PROCEDURE notify();

create or replace function notify_update() RETURNS trigger AS '
  BEGIN
    IF tg_op = ''UPDATE'' THEN
      INSERT INTO Notification (assessment_id, doctor_id)
          VALUES (old.id, new.attendingphysician);
    RETURN new;
    END IF;
  END
  ' LANGUAGE plpgsql;

create TRIGGER notify_update_trigger AFTER UPDATE OF attendingphysician ON Assessment FOR each ROW
EXECUTE PROCEDURE notify_update();
