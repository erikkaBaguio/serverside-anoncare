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