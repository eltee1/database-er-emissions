/*
 * brn_sectorgroup_basename_dataset_toid
 * -------------------------------------
 * Procedure die de kolommen dataset en basename van de meegegeven tabel in de gelijknamige tabellen zet en vervangt door id's. Na deze actie worden de foerign_keys gezet naar de 
 * tabellen dataset en basename via de id's.
 * Hierdoor worden deze tabellen tot 60% kleiner, wat allerlei voordelen met zich meebrengt: queries op de tabellen worden veel sneller en de de tabellen nemen veel minder ruimte in.
 * @param v_tablename De tabel waar de acties op moeten worden uitgevoerd.
 */
CREATE OR REPLACE PROCEDURE brn_sectorgroup_basename_dataset_toid (v_tablename text)
AS
$BODY$
DECLARE 
	v_sql text;
	v_verdict text;

BEGIN
	--aanmaken twee id-kolommen voor dataset en basename in de doeltabel
	RAISE NOTICE 'Maak twee de id-kolommen dataset_id en basename_id aan in tabel % als deze nog niet bestaan...', v_tablename;
	
	v_sql := 'ALTER TABLE ' || v_tablename ||' ADD COLUMN IF NOT EXISTS dataset_id integer;';
	EXECUTE v_sql;
	v_sql := 'ALTER TABLE ' || v_tablename ||' ADD COLUMN IF NOT EXISTS basename_id integer;';
	EXECUTE v_sql;

	--vullen koppeltabellen met unieke data incl id
	RAISE NOTICE 'Vul de koppeltabellen basename en dataset met de unieke data uit tabel %...', v_tablename;
	v_sql := 'INSERT INTO basename (basename_omschrijving) SELECT DISTINCT basename FROM ' || v_tablename ||' ORDER BY 1 ON CONFLICT DO NOTHING;';
	EXECUTE v_sql;

	v_sql := 'INSERT INTO dataset (dataset_omschrijving) SELECT DISTINCT dataset FROM ' || v_tablename ||' ORDER BY 1 ON CONFLICT DO NOTHING;';
	EXECUTE v_sql;

	--update de nieuwe id-kolommen in de parent tabel
	RAISE NOTICE 'Update de nieuwe id-kolommen in de parent tabel % met de id''s uit dataset en basename...', v_tablename;
	v_sql := 'UPDATE ' || v_tablename ||' 
				SET dataset_id = subquery.dataset_id
				FROM (SELECT distinct dataset.dataset_id, ' || v_tablename ||'.dataset
						FROM dataset
							INNER JOIN ' || v_tablename ||' ON dataset.dataset_omschrijving = ' || v_tablename ||'.dataset) AS subquery
						WHERE ' || v_tablename ||'.dataset = subquery.dataset;';
	EXECUTE v_sql;

	v_sql := 'UPDATE ' || v_tablename ||'
				SET basename_id = subquery.basename_id
				FROM (SELECT distinct basename.basename_id, ' || v_tablename ||'.basename
						FROM basename
							INNER JOIN ' || v_tablename ||' ON basename.basename_omschrijving = ' || v_tablename ||'.basename) AS subquery
						WHERE ' || v_tablename ||'.basename = subquery.basename;';
	EXECUTE v_sql;

	--aanmaken constraints naar basename en dataset tabellen
	RAISE NOTICE 'aanmaken FK constraints voor dataset_id en basename_id richting resp. dataset en basename tabellen voor tabel %.', v_tablename;
	v_sql := 'ALTER TABLE ' || v_tablename ||' ADD CONSTRAINT ' || v_tablename ||'_fkey_dataset FOREIGN KEY (dataset_id) REFERENCES dataset;';
	EXECUTE v_sql;
	v_sql := 'ALTER TABLE ' || v_tablename ||' ADD CONSTRAINT ' || v_tablename ||'_fkey_basename FOREIGN KEY (basename_id) REFERENCES basename;';
	EXECUTE v_sql;
	
	--check
	RAISE NOTICE 'Check of de id''s in % overeenkomenen met de texten zoals deze staan in dataset en basename en voer een rollback uit als dit niet het geval is...', v_tablename;
	v_sql := 
		'WITH id_check AS (
		SELECT
			' || v_tablename ||'.basename = basename.basename_omschrijving as basename_check,
			' || v_tablename ||'.dataset = dataset.dataset_omschrijving as dataset_check
	
			FROM ' || v_tablename ||'
				INNER JOIN dataset USING (dataset_id)
				INNER JOIN basename USING (basename_id)
		)
		SELECT (COUNT(*) = 0) 
			FROM id_check 
			WHERE 
				basename_check IS FALSE 
				OR dataset_check IS FALSE;';
	EXECUTE v_sql INTO v_verdict ;

	RAISE NOTICE 'verdict = %', v_verdict;

	IF v_verdict = 'true' THEN
		BEGIN	
			v_sql := 'ALTER TABLE ' || v_tablename ||' DROP COLUMN dataset;';
			EXECUTE v_sql;
			
			v_sql := 'ALTER TABLE ' || v_tablename ||' DROP COLUMN basename;';
			EXECUTE v_sql;
			
			COMMIT;
			
			RAISE NOTICE 'check geslaagd, kolommen dataset en basename verwijderd uit %, wijzigingen gecommit!', v_tablename;
		END;
	ELSE
		BEGIN
			RAISE NOTICE 'check gefaald, rollback uitgevoerd voor %. Controleer de verwerking van basename en dataset id''s', v_tablename;

			ROLLBACK;
		END;
	END IF;


END;
$BODY$
LANGUAGE plpgsql;
