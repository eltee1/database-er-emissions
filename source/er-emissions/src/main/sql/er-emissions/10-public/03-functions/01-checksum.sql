/*
 * checksum_table
 * --------------
 * Functie die een checksum-waarde retourneert voor een gegeven table_name. 
 * Wordt gebruikt door functies die de checksum invullen in de metadata tabel, om hiermee tabellen op inhoud te kunnen vergelijken tussen databases op verschillende locaties.
 * @param v_tablename De tabelnaam waarvan de checksum moet worden gegenereerd.
 */
CREATE OR REPLACE FUNCTION checks.checksum_table(v_tablename text)
	RETURNS SETOF bigint AS
$BODY$
DECLARE v_sql text;
BEGIN
	v_sql := 'SELECT COALESCE(SUM(hashtext((checksum_table.*)::text)), 0)::bigint AS checksum FROM ' || v_tablename || ' AS checksum_table;';
	RETURN QUERY EXECUTE v_sql;
END;
	
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * checksum_metadata
 * -----------------
 * Functie die de checksum_change- kolom in de metadata-tabel vult voor alle tabellen die in de metadata tabel staan, met de waarde zoals gegeven door de functie checks.checksum_table.
 */
CREATE OR REPLACE FUNCTION checks.checksum_metadata()
	RETURNS void AS
$BODY$
DECLARE
	v_tablename text;
	v_checksum bigint;
BEGIN
	FOR v_tablename IN 
		SELECT table_name FROM checks.metadata
	LOOP
		RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
		v_checksum:= checks.checksum_table(v_tablename);
		
		UPDATE checks.metadata 
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
 * Functie die voor een specifieke tabel de checksum_change- kolom in de metadata-tabel vult met de waarde zoals gegeven door de functie checks.checksum_table.
 */
CREATE OR REPLACE FUNCTION checks.checksum_singe_table(v_tablename text)
	RETURNS void AS
$BODY$
DECLARE
	v_checksum bigint;
BEGIN
	RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
	v_checksum:= checks.checksum_table(v_tablename);
	
	IF EXISTS (SELECT * FROM checks.metadata WHERE table_name = v_tablename) THEN
		UPDATE checks.metadata 
			SET 
				checksum_change = v_checksum,
				timestamp_checksum_change = to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS')
			WHERE table_name = v_tablename;
	ELSE
		INSERT INTO checks.metadata (table_name, checksum_change, timestamp_checksum_change) VALUES (v_tablename, v_checksum, to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS'));
	END IF;
END;
$BODY$
	LANGUAGE plpgsql volatile;


/*
 * checksum_public_brn_tables
 * --------------------------
 * Functie die voor alle tabellen in het public-schema de checksum_change- kolom in de metadata-tabel vult, met de waarde zoals gegeven door de functie checks.checksum_table.
 */
CREATE OR REPLACE FUNCTION checks.checksum_public_brn_tables()
	RETURNS void AS
$BODY$
DECLARE
	v_tablename text;
	v_sql text;
	v_checksum bigint;
BEGIN	
	FOR v_tablename IN
		SELECT CASE 
			WHEN table_schema = 'public' THEN table_name 
			WHEN table_schema <> 'public' THEN CONCAT(table_schema, '.', table_name) 
			ELSE NULL END AS tablename
			
			FROM information_schema.tables
			WHERE
				table_type = 'BASE TABLE'
				AND table_schema IN ('public', 'brn')
			ORDER BY table_name
	LOOP
		RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
		v_checksum := checks.checksum_table(v_tablename);
		
		IF EXISTS (SELECT * FROM checks.metadata WHERE table_name = v_tablename) THEN
			UPDATE checks.metadata 
				SET 
					checksum_change = v_checksum,
					timestamp_checksum_change = to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS')
				WHERE table_name = v_tablename;
		ELSE
			INSERT INTO checks.metadata (table_name, checksum_change, timestamp_checksum_change) VALUES (v_tablename, v_checksum, to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS'));
		END IF;

	END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
