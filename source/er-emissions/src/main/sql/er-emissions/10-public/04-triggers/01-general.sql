--aanmaken van alle triggers op het public-schema

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
