/*
 * checksum_table
 * --------------
 * Functie die een checksum-waarde retourneert voor een gegeven table_name. 
 * Wordt gebruikt door functies die de checksum invullen in de metadata tabel, om hiermee tabellen op inhoud te kunnen vergelijken tussen databases op verschillende locaties.
 * @param v_tablename De tabelnaam waarvan de checksum moet worden gegenereerd.
 */
CREATE OR REPLACE FUNCTION system.checksum_table(v_tablename text)
	RETURNS SETOF bigint AS
$BODY$
BEGIN
	RETURN QUERY EXECUTE
		format('SELECT COALESCE(SUM(hashtext((checksum_table.*)::text)), 0)::bigint AS checksum FROM %I AS checksum_table', v_tablename);
END;
	
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * checksum_metadata
 * -----------------
 * Functie die de checksum_change- kolom in de metadata-tabel vult voor alle tabellen die in de metadata tabel staan, met de waarde zoals gegeven door de functie system.checksum_table.
 */
CREATE OR REPLACE FUNCTION system.checksum_metadata()
	RETURNS void AS
$BODY$
DECLARE
	v_tablename text;
	v_checksum bigint;
BEGIN
	FOR v_tablename IN 
		SELECT table_name FROM metadata
	LOOP
		RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
		v_checksum:= system.checksum_table(v_tablename);
		
		UPDATE metadata 
			SET 
				checksum_change = v_checksum,
				timestamp_checksum_change = to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS')
			WHERE table_name = v_tablename;
	END LOOP;
END;
$BODY$
	LANGUAGE plpgsql volatile;


/*
 * checksum_singe_table
 * --------------------
 * Functie die voor een specifieke tabel de checksum_change- kolom in de metadata-tabel vult met de waarde zoals gegeven door de functie system.checksum_table.
 */
CREATE OR REPLACE FUNCTION system.checksum_singe_table(v_tablename text)
	RETURNS void AS
$BODY$
DECLARE
	v_checksum bigint;
BEGIN
	RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
	v_checksum:= system.checksum_table(v_tablename);
	
	IF EXISTS (SELECT * FROM metadata WHERE table_name = v_tablename) THEN
		UPDATE metadata 
			SET 
				checksum_change = v_checksum,
				timestamp_checksum_change = to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS')
			WHERE table_name = v_tablename;
	ELSE
		INSERT INTO metadata (table_name, checksum_change, timestamp_checksum_change) VALUES (v_tablename, v_checksum, to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS'));
	END IF;
END;
$BODY$
	LANGUAGE plpgsql volatile;

/*
 * checksum_public_tables
 * ----------------------
 * Functie die voor alle tabellen in het public-schema de checksum_change- kolom in de metadata-tabel vult, met de waarde zoals gegeven door de functie system.checksum_table.
 */
CREATE OR REPLACE FUNCTION system.checksum_public_tables()
	RETURNS void AS
$BODY$
DECLARE
	v_tablename text;
	v_sql text;
	v_checksum bigint;
BEGIN	
	FOR v_tablename IN
		SELECT table_name
			FROM information_schema.tables
			WHERE
				table_type = 'BASE TABLE'
				AND table_schema IN ('public')
				AND table_name <> 'metadata'
			ORDER BY table_name
	LOOP
		RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
		v_checksum := system.checksum_table(v_tablename);
		
		IF EXISTS (SELECT * FROM metadata WHERE table_name = v_tablename) THEN
			UPDATE metadata 
				SET 
					checksum_change = v_checksum,
					timestamp_checksum_change = to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS')
				WHERE table_name = v_tablename;
		ELSE
			INSERT INTO metadata (table_name, checksum_change, timestamp_checksum_change) VALUES (v_tablename, v_checksum, to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS'));
		END IF;

	END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
