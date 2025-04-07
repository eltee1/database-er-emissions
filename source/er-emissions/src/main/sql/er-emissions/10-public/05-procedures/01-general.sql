/*
 * brn_textcolumns_toid
 * --------------------
 * Procedure die de kolommen dataset en basename van de meegegeven tabel in koppeltabel dataset zet en vervangt door een id. Na deze actie worden er een foreign_key gezet naar de  
 * tabel dataset via de id en vindt er een check plaats op inhoud. Klopt deze niet, dan wordt de hele actie teruggedraaid.
 * Ook wordt een view aangemaakt die de originele data teruggeeft.
 * Door deze actie worden de tabellen ongeveer 50% kleiner, naast de afname in grootte is een bijkomend voordeel dat queries op deze tabellen (veel) sneller worden uitgevoerd.
 * @param v_tablename De tabel waar de acties op moeten worden uitgevoerd.
 */
CREATE OR REPLACE PROCEDURE brn_textcolumns_toid (v_tablename text)
AS
$BODY$
DECLARE 
	v_sql text;
	v_verdict text;

BEGIN
	--aanmaken id-kolom dataset_basename_id aan in de doeltabel
	RAISE NOTICE 'Maak de id-kolom dataset_id aan in tabel % als deze nog niet bestaat...', v_tablename;
	
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD COLUMN IF NOT EXISTS dataset_id integer;';
	EXECUTE v_sql;

	--vullen koppeltabel met unieke data incl id
	RAISE NOTICE 'Vul de koppeltabel dataset met de unieke data uit tabel %...', v_tablename;
	v_sql := 'INSERT INTO dataset (dataset_omschrijving, basename_omschrijving) SELECT DISTINCT dataset, basename FROM ' || v_tablename || ' ORDER BY 1 ON CONFLICT DO NOTHING;';
	EXECUTE v_sql;


	--update de nieuwe id-kolommen in de parent tabel
	RAISE NOTICE 'Update de nieuwe id-kolom in de parent tabel % met de id''s uit dataset koppeltabel...', v_tablename;
	v_sql := 'UPDATE ' || v_tablename || ' 
				SET dataset_id = subquery.dataset_id
				FROM 
					(SELECT DISTINCT dataset.dataset_id, ' || v_tablename ||'.dataset,  ' || v_tablename ||'.basename
						FROM dataset
							INNER JOIN ' || v_tablename || ' 
								ON dataset.dataset_omschrijving = ' || v_tablename ||'.dataset
								AND dataset.basename_omschrijving = ' || v_tablename ||'.basename
					) AS subquery
				WHERE 
					' || v_tablename ||'.dataset = subquery.dataset
					AND ' || v_tablename ||'.basename = subquery.basename;';
	EXECUTE v_sql;


	--aanmaken constraints naar basename en dataset tabellen
	RAISE NOTICE 'aanmaken FK constraint voor dataset_basename_id richting resp. dataset_basename tabel voor %.', v_tablename;
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD CONSTRAINT ' || v_tablename ||'_fkey_dataset FOREIGN KEY (dataset_id) REFERENCES dataset;';
	EXECUTE v_sql;
	
	--check
	RAISE NOTICE 'Check of de id''s in % overeenkomenen met de texten zoals deze staan in dataset en voer een rollback uit als dit niet het geval is...', v_tablename;
	v_sql := 
		'WITH id_check AS (
		SELECT
			' || v_tablename ||'.dataset = dataset.dataset_omschrijving as dataset_check,
			' || v_tablename ||'.basename = dataset.basename_omschrijving as basename_check
	
			FROM ' || v_tablename || '
				INNER JOIN dataset USING (dataset_id)
		)
		SELECT (COUNT(*) = 0) 
			FROM id_check 
			WHERE 
				dataset_check IS FALSE 
				OR basename_check IS FALSE;';
	EXECUTE v_sql INTO v_verdict ;

	RAISE NOTICE 'verdict = %', v_verdict;

	IF v_verdict = 'true' THEN
		BEGIN	
			RAISE NOTICE 'check geslaagd; id-kolom succesvol aangemaakt. Nu kolommen dataset, basename verwijderen uit % , en een view aanmaken die de brontabel aanvult met de texten ipv de ids.', v_tablename;
			v_sql := 'ALTER TABLE ' || v_tablename || ' DROP COLUMN dataset;';
			EXECUTE v_sql;
			v_sql := 'ALTER TABLE ' || v_tablename || ' DROP COLUMN basename;';
			EXECUTE v_sql;

			v_sql :=
				'CREATE OR REPLACE VIEW ' || v_tablename || '_view AS
				SELECT 
					snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bronomschrijving, gcn_sector_id, substance_id, 
					dataset.dataset_omschrijving as dataset, dataset.basename_omschrijving as basename
		
				FROM ' || v_tablename || '
					INNER JOIN dataset USING (dataset_id)

				;';
			EXECUTE v_sql;
			v_sql := 'COMMENT ON VIEW ' || v_tablename || '_view IS ''View die de data terugeeft uit ' || v_tablename || ' , aangevuld met de bron-, dataset- en basename omschrijvingen ipv de ids.'';';
			EXECUTE v_sql;
		
			--COMMIT;
			RAISE NOTICE 'wijzigingen gecommit voor tabel %!', v_tablename;
		END;
	ELSE
		BEGIN
			RAISE NOTICE 'check gefaald, rollback uitgevoerd voor %. Controleer de verwerking van basename id''s', v_tablename;
			ROLLBACK;
		END;
	END IF;


END;
$BODY$
LANGUAGE plpgsql;


/*
 * brn_textcolumns_toid_old
 * ------------------------
 * Procedure die de kolommen dataset, basename en bronomschrijving van de meegegeven tabel in koppel tabellen zet en vervangt door id's. Na deze actie worden er foreign_keys gezet naar de 
 * tabellen dataset, basename en bron via de id's en vindt er een check plaats op inhoud. Klopt deze niet, dan wordt de hele actie teruggedraaid.
 * Ook wordt een view aangemaakt die de originele data teruggeeft.
 * Door deze actie worden de tabellen ongeveer 56% kleiner, naast de afname in grootte is een bijkomend voordeel dat queries op deze tabellen (veel) sneller worden uitgevoerd.
 * @param v_tablename De tabel waar de acties op moeten worden uitgevoerd.
 */
CREATE OR REPLACE PROCEDURE brn_textcolumns_toid_old (v_tablename text)
AS
$BODY$
DECLARE 
	v_sql text;
	v_verdict text;

BEGIN
	--aanmaken drie id-kolommen voor dataset, basename en bron in de doeltabel
	RAISE NOTICE 'Maak de id-kolommen dataset_id, basename_id en bron_id aan in tabel % als deze nog niet bestaan...', v_tablename;
	
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD COLUMN IF NOT EXISTS dataset_id integer;';
	EXECUTE v_sql;
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD COLUMN IF NOT EXISTS basename_id integer;';
	EXECUTE v_sql;
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD COLUMN IF NOT EXISTS bron_id integer;';
	EXECUTE v_sql;

	--vullen koppeltabellen met unieke data incl id
	RAISE NOTICE 'Vul de koppeltabellen basename, dataset en bron met de unieke data uit tabel %...', v_tablename;
	v_sql := 'INSERT INTO basename (basename_omschrijving) SELECT DISTINCT basename FROM ' || v_tablename || ' ORDER BY 1 ON CONFLICT DO NOTHING;';
	EXECUTE v_sql;

	v_sql := 'INSERT INTO dataset (dataset_omschrijving) SELECT DISTINCT dataset FROM ' || v_tablename || ' ORDER BY 1 ON CONFLICT DO NOTHING;';
	EXECUTE v_sql;

	v_sql := 'INSERT INTO bron (bron_omschrijving) SELECT DISTINCT bronomschrijving FROM ' || v_tablename || ' ORDER BY 1 ON CONFLICT DO NOTHING;';
	EXECUTE v_sql;

	--update de nieuwe id-kolommen in de parent tabel
	RAISE NOTICE 'Update de nieuwe id-kolommen in de parent tabel % met de id''s uit dataset, basename en bron...', v_tablename;
	v_sql := 'UPDATE ' || v_tablename || ' 
				SET dataset_id = subquery.dataset_id
				FROM (SELECT DISTINCT dataset.dataset_id, ' || v_tablename ||'.dataset
						FROM dataset
							INNER JOIN ' || v_tablename || ' ON dataset.dataset_omschrijving = ' || v_tablename ||'.dataset) AS subquery
						WHERE ' || v_tablename ||'.dataset = subquery.dataset;';
	EXECUTE v_sql;

	v_sql := 'UPDATE ' || v_tablename || '
				SET basename_id = subquery.basename_id
				FROM (SELECT DISTINCT basename.basename_id, ' || v_tablename ||'.basename
						FROM basename
							INNER JOIN ' || v_tablename || ' ON basename.basename_omschrijving = ' || v_tablename ||'.basename) AS subquery
						WHERE ' || v_tablename ||'.basename = subquery.basename;';
	EXECUTE v_sql;

		v_sql := 'UPDATE ' || v_tablename || '
				SET bron_id = subquery.bron_id
				FROM (SELECT DISTINCT bron.bron_id, ' || v_tablename ||'.bronomschrijving
						FROM bron
							INNER JOIN ' || v_tablename || ' ON bron.bron_omschrijving = ' || v_tablename ||'.bronomschrijving) AS subquery
						WHERE ' || v_tablename ||'.bronomschrijving = subquery.bronomschrijving;';
	EXECUTE v_sql;

	--aanmaken constraints naar basename en dataset tabellen
	RAISE NOTICE 'aanmaken FK constraints voor dataset_id,  basename_id  en bron_id richting resp. dataset-, basename- en bron tabellen voor tabel %.', v_tablename;
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD CONSTRAINT ' || v_tablename ||'_fkey_dataset FOREIGN KEY (dataset_id) REFERENCES dataset;';
	EXECUTE v_sql;
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD CONSTRAINT ' || v_tablename ||'_fkey_basename FOREIGN KEY (basename_id) REFERENCES basename;';
	EXECUTE v_sql;
	v_sql := 'ALTER TABLE ' || v_tablename || ' ADD CONSTRAINT ' || v_tablename ||'_fkey_bron FOREIGN KEY (bron_id) REFERENCES bron;';
	EXECUTE v_sql;
	
	--check
	RAISE NOTICE 'Check of de id''s in % overeenkomenen met de texten zoals deze staan in dataset, basename en bron en voer een rollback uit als dit niet het geval is...', v_tablename;
	v_sql := 
		'WITH id_check AS (
		SELECT
			' || v_tablename ||'.basename = basename.basename_omschrijving as basename_check,
			' || v_tablename ||'.dataset = dataset.dataset_omschrijving as dataset_check,
			' || v_tablename ||'.bronomschrijving = bron.bron_omschrijving as bron_check
	
			FROM ' || v_tablename || '
				INNER JOIN dataset USING (dataset_id)
				INNER JOIN basename USING (basename_id)
				INNER JOIN bron USING (bron_id)
		)
		SELECT (COUNT(*) = 0) 
			FROM id_check 
			WHERE 
				basename_check IS FALSE 
				OR dataset_check IS FALSE
				OR bron_check IS FALSE ;';
	EXECUTE v_sql INTO v_verdict ;

	RAISE NOTICE 'verdict = %', v_verdict;

	IF v_verdict = 'true' THEN
		BEGIN	
			RAISE NOTICE 'check geslaagd; id-kolommen succesvol aangemaakt. Nu kolommen dataset, basename en bronomschrijving verwijderen uit % , en een view aanmaken die de brontabel aanvult met de texten ipv de ids.', v_tablename;
			v_sql := 'ALTER TABLE ' || v_tablename || ' DROP COLUMN dataset;';
			EXECUTE v_sql;
			v_sql := 'ALTER TABLE ' || v_tablename || ' DROP COLUMN basename;';
			EXECUTE v_sql;
			v_sql := 'ALTER TABLE ' || v_tablename || ' DROP COLUMN bronomschrijving;';
			EXECUTE v_sql;

			v_sql :=
				'CREATE OR REPLACE VIEW ' || v_tablename || '_view AS
				SELECT 
					snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
					dataset.dataset_omschrijving as dataset, basename.basename_omschrijving as basename
		
				FROM ' || v_tablename || '
					INNER JOIN dataset USING (dataset_id)
					INNER JOIN basename USING (basename_id)
					INNER JOIN bron USING (bron_id)
				;';
			EXECUTE v_sql;
			v_sql := 'COMMENT ON VIEW ' || v_tablename || '_view IS ''View die de data terugeeft uit ' || v_tablename || ' , aangevuld met de bron-, dataset- en basename omschrijvingen ipv de ids.'';';
			EXECUTE v_sql;
		
			COMMIT;
			RAISE NOTICE 'wijzigingen gecommit voor tabel %!', v_tablename;
		END;
	ELSE
		BEGIN
			RAISE NOTICE 'check gefaald, rollback uitgevoerd voor %. Controleer de verwerking van basename, dataset en bronomschrijving id''s', v_tablename;
			ROLLBACK;
		END;
	END IF;


END;
$BODY$
LANGUAGE plpgsql;
