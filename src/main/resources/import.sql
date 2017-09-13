CREATE OR REPLACE FUNCTION person_table_update_notify() RETURNS trigger AS $$ DECLARE  id varchar(255);  first_name varchar(255);  last_name varchar(255);BEGIN  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN    id = NEW.id;    first_name = NEW.first_name;    last_name = NEW.last_name;  ELSE    id = OLD.id;    first_name = OLD.first_name;    last_name = OLD.last_name;  END IF;  PERFORM pg_notify('person_table_update', json_build_object('id', id, 'first_name', first_name, 'last_name', last_name)::text);  RETURN NEW;END;$$ LANGUAGE plpgsql;

--DROP TRIGGER person_notify_update on person;
CREATE TRIGGER person_notify_update AFTER UPDATE ON person FOR EACH ROW EXECUTE PROCEDURE person_table_update_notify();

--DROP TRIGGER person_notify_insert on person;
CREATE TRIGGER person_notify_insert AFTER INSERT ON person FOR EACH ROW EXECUTE PROCEDURE person_table_update_notify();

--DROP TRIGGER person_notify_delete on person;
CREATE TRIGGER person_notify_delete AFTER DELETE ON person FOR EACH ROW EXECUTE PROCEDURE person_table_update_notify();
