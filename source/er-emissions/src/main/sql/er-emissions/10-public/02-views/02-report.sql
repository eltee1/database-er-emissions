/*
 * emissions_ammonia_agriculture_nl
 * --------------------------------
 * View die de stikstof-emissie van de landbouwsector retourneert, uitgesplitst in 9 (deels samengestelde) deelsectoren. 
 * De emissies worden weergegeven in kton per jaar per sector, voor de jaren 2005 t/m 2040. 
 */
CREATE OR REPLACE VIEW report.emissions_ammonia_agriculture_nl AS
WITH 
sector_emissions_per_sector AS (
	SELECT 
		dataset_omschrijving AS dataset,
		jaar AS emission_year,
		CASE 
			WHEN gcn_sectors.sector_id = 4130 THEN 'Beweiding'
			WHEN gcn_sectors.sector_id = 4140 THEN 'Mestaanwending'
			WHEN gcn_sectors.sector_id IN (4120, 4150) THEN 'Mestopslag & mestbewerking'
			WHEN gcn_sectors.sector_id = 4160 THEN 'Particuliere landbouwactiviteiten'
			WHEN gcn_sectors.sector_id IN (4600, 4320) THEN 'Overige landbouw'
			WHEN gcn_sectors.sector_id = 4114 THEN 'Stallen Overig vee'
			WHEN gcn_sectors.sector_id = 4113 THEN 'Stallen Pluimvee'
			WHEN gcn_sectors.sector_id = 4111 THEN 'Stallen Rundvee'
			WHEN gcn_sectors.sector_id = 4112 THEN 'Stallen Varkens'
			ELSE CAST(gcn_sectors.sector_id AS text)
		END AS sector,
		SUM(emissie_kg) AS summed_emission 
		
		FROM emissie_totalen 
			INNER JOIN gcn_sectors USING (gcn_sector_id)
			INNER JOIN pbl_sectors USING (gcn_sector_id)
			INNER JOIN dataset USING (dataset_id)
			
		WHERE 
			pbl_sectors.pbl_sector = 'Landbouw'
			AND jaar > 2004
			AND substance_id = 17
			
		GROUP BY dataset_omschrijving, jaar, gcn_sectors.sector_id, substance_id

),
total_emissions AS (
	SELECT 
		dataset,
		emission_year,
		'Totaal' AS sector,
		SUM(summed_emission) AS total_summed_emission

		FROM sector_emissions_per_sector

		WHERE sector IS NOT NULL

		GROUP BY dataset, emission_year
)
SELECT 
	dataset,
	emission_year,
	sector,
	'NH3' AS substance,
	SUM(summed_emission) / 1000000 AS emissie_in_kton

	FROM sector_emissions_per_sector

	WHERE sector IS NOT NULL

	GROUP BY dataset, emission_year, sector

UNION

SELECT 
	dataset,
	emission_year,
	sector,
	'NH3' AS substance,
	total_summed_emission / 1000000  AS emissie_in_kton

	FROM total_emissions

	ORDER BY emission_year, sector
;


/*
 * emissions_nitrogen_oxides_mobility_nl
 * -------------------------------------
 * View die de stikstof-emissie van de mobiliteitssector  retourneert, uitgesplitst in 7 (deels samengestelde) deelsectoren. 
 * De emissies worden weergegeven in kton per jaar per sector, voor de jaren 2005 t/m 2040. 
 */
CREATE OR REPLACE VIEW report.emissions_nitrogen_oxides_mobility_nl AS
WITH 
sector_emissions_per_sector AS (
	SELECT 
		dataset_omschrijving AS dataset,
		jaar AS emissiejaar,
		CASE 
			WHEN gcn_sectors.sector_id IN (7630) THEN 'Binnenvaart'
			WHEN gcn_sectors.sector_id IN (3210, 3220, 3240, 3530) THEN 'Mobiele werktuigen'
			WHEN gcn_sectors.sector_id IN (3640, 3650, 3720) THEN 'Luchtvaart & spoor'
			WHEN gcn_sectors.sector_id IN (7620) THEN 'Visserij'
			WHEN gcn_sectors.sector_id IN (3111, 3112, 3113, 3114) THEN 'Wegverkeer'
			WHEN gcn_sectors.sector_id IN (7510, 7520, 7530) THEN 'Zeescheepvaart'
			ELSE NULL
		END AS sector,
		SUM(emissie_kg) AS summed_emission --m25: kolomnaam emissie_kg
		
		FROM emissie_totalen 
			INNER JOIN gcn_sectors USING (gcn_sector_id)
			INNER JOIN pbl_sectors USING (gcn_sector_id)
			INNER JOIN dataset USING (dataset_id)
			
		WHERE 
			pbl_sectors.pbl_sector = 'Mobiliteit'
			AND jaar > 2004
			AND substance_id = 11
		GROUP BY dataset_omschrijving, jaar, gcn_sectors.sector_id, substance_id
),
total_emissions AS (
	SELECT 
		dataset,
		emissiejaar,
		'Totaal' AS sector,
		SUM(summed_emission) AS total_summed_emission

		FROM sector_emissions_per_sector

		WHERE sector IS NOT NULL

		GROUP BY dataset, emissiejaar
)
SELECT 
	dataset,
	emissiejaar,
	sector,
	'NOx' AS substance,
	SUM(summed_emission) / 1000000 AS emissie_in_kton

	FROM sector_emissions_per_sector

	WHERE sector IS NOT NULL

	GROUP BY dataset, emissiejaar, sector

UNION

SELECT 
	dataset,
	emissiejaar,
	sector,
	'NOx' AS substance,
	total_summed_emission / 1000000  AS emissie_in_kton

	FROM total_emissions

	ORDER BY emissiejaar, sector
;


/*
 * emissions_ammonia_nl
 * --------------------
 * View die de ammoniak-emissie in kton per PBL-sector, jaar en substance retourneert vanaf 2005 t/m 2040. 
 */
CREATE OR REPLACE VIEW report.emissions_ammonia_nl AS
WITH emissions_all_sectors AS (
	SELECT 
		dataset_omschrijving AS dataset,
		jaar AS emission_year,
		pbl_sectors.pbl_sector AS sector,
		substance_id,
		sum(emissie_kg) AS summed_emission

		FROM emissie_totalen
			INNER JOIN pbl_sectors USING (gcn_sector_id)
			INNER JOIN dataset USING (dataset_id)
			
		WHERE 
			jaar > 2004
			AND substance_id = 17
			
		GROUP BY dataset_omschrijving, jaar, pbl_sectors.pbl_sector, substance_id
),
total_emissions AS (
	SELECT 
		dataset,
		emission_year,
		'Totaal' AS sector,
		SUM(summed_emission) AS total_summed_emission

		FROM emissions_all_sectors
			
		GROUP BY dataset, emission_year
)
SELECT 
	dataset,
	emission_year,
	sector,
	'NH3' AS substance,
	SUM(summed_emission) / 1000000 AS emissie_in_kton

	FROM emissions_all_sectors

	GROUP BY dataset, emission_year, sector

UNION

SELECT 
	dataset,
	emission_year,
	sector,
	'NH3' AS substance,
	total_summed_emission / 1000000 AS emissie_in_kton

	FROM total_emissions

	ORDER BY emission_year, sector
;


/*
 * emissions_nitrogen_oxides_nl
 * ----------------------------
 * View die de stikstofoxiden-emissie in kton per PBL-sector, jaar en substance retourneert vanaf 2005 t/m 2040. 
 */
CREATE OR REPLACE VIEW report.emissions_nitrogen_oxides_nl AS
WITH emissions_all_sectors AS (
	SELECT 
		dataset_omschrijving AS dataset,
		jaar AS emission_year,
		pbl_sectors.pbl_sector AS sector,
		substance_id,
		sum(emissie_kg) AS summed_emission

		FROM emissie_totalen
			INNER JOIN pbl_sectors USING (gcn_sector_id)
			INNER JOIN dataset USING (dataset_id)
		
		WHERE 
			jaar > 2004
			AND substance_id = 11
			
		GROUP BY dataset_omschrijving, jaar, pbl_sectors.pbl_sector, substance_id
),
total_emissions AS (
	SELECT 
		dataset,
		emission_year,
		'Totaal' AS sector,
		SUM(summed_emission) AS total_summed_emission

		FROM emissions_all_sectors
			
		GROUP BY dataset, emission_year
)
SELECT 
	dataset,
	emission_year,
	sector,
	'NOx' AS substance,
	SUM(summed_emission) / 1000000 AS emissie_in_kton

	FROM emissions_all_sectors

	GROUP BY dataset, emission_year, sector

UNION

SELECT 
	dataset,
	emission_year,
	sector,
	'NOx' AS substance,
	total_summed_emission / 1000000 AS emissie_in_kton

	FROM total_emissions

	ORDER BY emission_year, sector
;
