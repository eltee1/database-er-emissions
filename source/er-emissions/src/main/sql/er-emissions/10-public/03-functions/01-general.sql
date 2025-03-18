/*
 * checksum_table
 * --------------
 * Functie die een checksum-waarde retourneert voor een gegeven table_name. 
 * Wordt gebruikt door system.fill_metadata_checksum, om tabellen op inhoud en structuur te kunnen vergelijk tussen databases op verschillende locaties.
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
 * fill_metadata_checksum
 * ----------------------
 * Functie die de checksum_hash- kolomn in de metadata-tabel vult aan de hand van de corresponderende table_name kolom, met de waarde zoals gegeven door de functie system.checksum_table.
 */
CREATE OR REPLACE FUNCTION system.fill_metadata_checksum()
	RETURNS VOID AS
$BODY$
DECLARE
	v_table text;
	v_checksum bigint;
BEGIN
	FOR v_table IN 
		SELECT table_name FROM metadata
	LOOP
		v_checksum:= system.checksum_table(v_table);
		
		UPDATE metadata SET checksum_hash = v_checksum 
			WHERE table_name = v_table;
	END LOOP;

END;
$BODY$
	LANGUAGE plpgsql volatile;


/*
 * fill_metadata_checksum_trigger
 * ------------------------------
 * Trigger-functie die de checksum_hash- kolomn in de metadata-tabel vult aan de hand vanuit de trigger op elke tabel in het public-schema.
 * Als de inhoud van een tabel in public wordt aangepast, dan gaat de trigger af en wordt de checksum-hash van de betreffende tabel in tabel metadata geupdated.
 * TG_RELNAME = de tabelnaam die via de trigger wordt doorgegeven.
 */
CREATE OR REPLACE FUNCTION system.fill_metadata_checksum_trigger()
	RETURNS trigger AS
$BODY$
DECLARE
	v_checksum bigint := system.checksum_table(TG_RELNAME::text);
BEGIN
	IF EXISTS (SELECT * FROM metadata WHERE table_name = TG_RELNAME::text) THEN
		BEGIN
			UPDATE metadata SET checksum_hash = v_checksum 
				WHERE table_name = TG_RELNAME::text;
			RETURN NULL;
		END;
	ELSE
		BEGIN
			INSERT INTO metadata (table_name, filename, checksum_hash)
				VALUES (TG_RELNAME::text, 'data niet via load_table geimporteerd of handmatig aangepast', v_checksum);
			RETURN NULL;
		END;
	END IF;
END;

$BODY$
	LANGUAGE plpgsql;


/*
 * create_checksum_triggers
 * ------------------------------
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
