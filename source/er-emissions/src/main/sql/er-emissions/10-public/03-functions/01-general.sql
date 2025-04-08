/*
 * checksum_table
 * --------------
 * Functie die een checksum-waarde retourneert voor een gegeven table_name. 
 * Wordt gebruikt door functies die de checksum invullen in de metadata tabel, om hiermee tabellen op inhoud te kunnen vergelijken tussen databases op verschillende locaties.
 * @param v_table De tabelnaam waarvan de checksum moet worden gegenereerd.
 */
CREATE OR REPLACE FUNCTION system.checksum_table(v_table text)
	RETURNS SETOF bigint AS
$BODY$
BEGIN
	RETURN QUERY EXECUTE
		format('SELECT COALESCE(SUM(hashtext((checksum_table.*)::text)), 0)::bigint AS checksum FROM %I AS checksum_table', v_table);
END;
	
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * checksum_change
 * ---------------
 * Functie die de checksum_change- kolom in de metadata-tabel vult aan de hand van de corresponderende table_name kolom, met de waarde zoals gegeven door de functie system.checksum_table.
 */
CREATE OR REPLACE FUNCTION system.checksum_metadata()
	RETURNS VOID AS
$BODY$
DECLARE
	v_tablename text;
	v_checksum bigint;
BEGIN
	FOR v_table IN 
		SELECT table_name FROM metadata
	LOOP
		RAISE NOTICE 'checksum_change bepalen voor: %...', v_tablename;
		
		v_checksum:= system.checksum_table(v_tablename);
		
		UPDATE metadata SET checksum_change = v_checksum 
			WHERE table_name = v_tablename;
	END LOOP;
END;
$BODY$
	LANGUAGE plpgsql volatile;


/*
 * checksum_all
 * ------------
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
			UPDATE metadata SET checksum_change = v_checksum WHERE table_name = v_tablename;
		ELSE
			INSERT INTO metadata (table_name, checksum_change) VALUES (v_tablename, v_checksum);
		END IF;

	END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
