/*
 * create_checksum_triggers
 * ------------------------
 * Trigger-functie op elke tabel in het public-schema, muv de metadata-tabel, een trigger zet die automatisch de checksum in de metadata-tabel update voor
 * de betreffende tabel.
 */
CREATE OR REPLACE FUNCTION system.create_checksum_triggers()
	RETURNS void AS
$BODY$
DECLARE
	v_table_name text;
	v_sql text;
BEGIN
	FOR v_table_name IN
		SELECT table_name
			FROM information_schema.tables
			WHERE
				table_type = 'BASE TABLE'
				AND table_schema IN ('public')
				AND table_name <> 'metadata'
			ORDER BY table_name
	LOOP
		v_sql := 'CREATE TRIGGER iut_' || v_table_name || '_metadata_update' || ' AFTER INSERT OR UPDATE ON public.' 
				|| v_table_name || ' EXECUTE PROCEDURE system.fill_metadata_checksum_trigger();';

		EXECUTE v_sql;
	END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


/*
 * create_checksum_triggers
 * ------------------------
 * Functie die de triggers aangemaakt door system.create_checksum_triggers, op elke tabel in schema public verwijdert.
 */
CREATE OR REPLACE FUNCTION system.drop_checksum_triggers()
	RETURNS void AS
$BODY$
DECLARE
	v_table_name text;
	v_sql text;
BEGIN
	FOR v_table_name IN
		SELECT table_name
			FROM information_schema.tables
			WHERE
				table_type = 'BASE TABLE'
				AND table_schema IN ('public')
				AND table_name <> 'metadata'
			ORDER BY table_name
	LOOP
		v_sql := 'DROP TRIGGER IF EXISTS iut_' || v_table_name || '_metadata_update ON ' || v_table_name || ' ;' ;

		EXECUTE v_sql;
	END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
