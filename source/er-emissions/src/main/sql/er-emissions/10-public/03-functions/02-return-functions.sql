/*
 * aer_brn_hist
 * ------------
 * Functie die is gemaakt in de plaats van een view per jaar; nu kan het jaar opgegeven worden als parameter in deze functie. 
 * Retourneert een tabel met geschaalde emissies van scenario 1 van alle hoofdsectoren per opgegeven jaar. 
 * @param v_year Het jaar waarvoor de data moet worden geretourneerd.
 */
CREATE OR REPLACE FUNCTION aer_brn_hist_test(v_year integer)
	RETURNS TABLE(snr integer, x_m bigint, y_m bigint, hc_mw double precision, h_m double precision, r_m bigint, s_m double precision, 
					dv bigint, cat integer, area bigint, ps bigint, component character varying, bronomschrijving character varying, 
					q_g_s double precision, gcn_sector_id integer, substance_id smallint, scale_factor real, scenario_id integer, 
					q_g_s_scaled double precision) AS
$BODY$
BEGIN

RETURN QUERY
WITH scale_factors AS (
	SELECT 
		year_from,
		year_to,
		scale_factors.gcn_sector_id,
		scale_factors.substance_id,
		scale_factors.scale_factor,
		scale_factors.scenario_id

		FROM gcn_sector_economic_scale_factors AS scale_factors
		
		WHERE 
			scale_factors.scenario_id = 1 
			AND year_to = v_year
)

SELECT 
	scale_factors.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	em.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	scale_factors.scale_factor,
	scale_factors.scenario_id,
	em.q_g_s * scale_factors.scale_factor AS q_g_s_scaled
	
	FROM aerius_m24_brn_agriculture AS em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
		INNER JOIN scale_factors USING (gcn_sector_id, substance_id)

UNION ALL

SELECT 
	scale_factors.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	em.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	scale_factors.scale_factor,
	scale_factors.scenario_id,
	em.q_g_s * scale_factors.scale_factor AS q_g_s_scaled
	
	FROM aerius_m24_brn_industry AS em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
		INNER JOIN scale_factors USING (gcn_sector_id, substance_id)
		
UNION ALL

SELECT 
	scale_factors.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	em.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	scale_factors.scale_factor,
	scale_factors.scenario_id,
	em.q_g_s * scale_factors.scale_factor AS q_g_s_scaled
	
FROM aerius_m24_brn_other AS em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
	INNER JOIN scale_factors USING (gcn_sector_id, substance_id)

UNION ALL

SELECT 
	scale_factors.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	em.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	scale_factors.scale_factor,
	scale_factors.scenario_id,
	em.q_g_s * scale_factors.scale_factor AS q_g_s_scaled

	FROM aerius_m24_brn_road_transportation AS em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
		INNER JOIN scale_factors USING (gcn_sector_id, substance_id)

UNION ALL

SELECT 
	scale_factors.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	em.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	scale_factors.scale_factor,
	scale_factors.scenario_id,
	em.q_g_s * scale_factors.scale_factor AS q_g_s_scaled

	FROM aerius_m24_brn_shipping AS em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
		INNER JOIN scale_factors USING (gcn_sector_id, substance_id)

UNION ALL

SELECT 
	scale_factors.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	em.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	scale_factors.scale_factor,
	scale_factors.scenario_id,
	em.q_g_s * scale_factors.scale_factor AS q_g_s_scaled

	FROM aerius_m24_brn_road_freeway em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
		INNER JOIN scale_factors USING (gcn_sector_id, substance_id)
;

END;
$BODY$
LANGUAGE 'plpgsql';


/*
 * gcn_brn_hist
 * ------------
 * Functie die is gemaakt in de plaats van een view per jaar; nu kan het jaar opgegeven worden als parameter in deze functie. 
 * Retourneert een tabel met geschaalde emissies van scenario 2 van gcn brondata per opgegeven jaar. 
 * @param v_year Het jaar waarvoor de data moet worden geretourneerd.
 */
 CREATE OR REPLACE FUNCTION gcn_brn_hist(v_year integer)
	RETURNS TABLE(snr bigint, x_m bigint, y_m bigint, hc_mw double precision, h_m real, r_m real, s_m real, dv smallint, cat bigint, 
					area smallint, ps smallint, component character varying, bronomschrijving character varying, q_g_s double precision, 
					gcn_sector_id integer, substance_id smallint, scale_factor double precision, scenario_id bigint, q_g_s_scaled double precision) AS
$BODY$
BEGIN

RETURN QUERY
SELECT 
	sf.year_to AS snr,
	em.x_m,
	em.y_m,
	em.hc_mw,
	em.h_m,
	em.r_m,
	em.s_m,
	em.dv,
	sf.gcn_sector_id AS cat,
	em.area,
	em.ps,
	em.component,
	em.bronomschrijving,
	em.q_g_s,
	em.gcn_sector_id,
	em.substance_id,
	sf.scale_factor,
	sf.scenario_id,
	em.q_g_s * sf.scale_factor AS q_g_s_scaled
	
	FROM gcn_24_brn AS em -- Todo: wordt nog een generieke tabel, dat hier aanpassen
		INNER JOIN 
			(SELECT 
				scale_factors.scenario_id,
				scale_factors.gcn_sector_id,
				scale_factors.substance_id,
				scale_factors.year_from,
				scale_factors.emissie_from,
				scale_factors.year_to,
				scale_factors.emissie_to,
				scale_factors.scale_factor
				
				FROM scale_factors
				
				WHERE 
					scale_factors.scenario_id = 2 
					AND scale_factors.year_to = v_year
			) AS sf USING (gcn_sector_id, substance_id)
	;
	
END;
$BODY$
LANGUAGE 'plpgsql';


/*
 * giab_hist
 * ---------
 * Functie die is gemaakt in de plaats van een view per jaar/stof/gcn_sector combinatie; nu kunnen deze opgegeven worden als parameter in deze functie. 
 * Retourneert een tabel met ....
 * @param v_year Het jaar waarvoor de data moet worden geretourneerd.
 * @param v_gcn_sector De gcn_sector waarvoor de data moet worden geretourneerd.
 * @param v_stof_code De stof_code waarvoor de data moet worden geretourneerd.
 */
CREATE OR REPLACE FUNCTION giab_hist(v_year integer, v_gcn_sector integer, v_stof_code integer)
	RETURNS TABLE(tle_id integer, ai_code character varying, ai_code_gen text, substance_id bigint, gcn_sector_id integer, 
					emissie_verfijnd double precision, emissiejaar integer,	relnr integer, relnr_pch_lbt_pch_nw_ubn character varying, 
					geom geometry, bouwjaar integer) AS
$BODY$
BEGIN

RETURN QUERY
SELECT 
	verf.tle_id,
	verf.ai_code,
	vk.ai_code AS ai_code_gen,
	s.substance_id,
	verf.idg_code::integer AS gcn_sector_id,
	verf.emissie AS emissie_verfijnd,
	verf.emissiejaar,
	giab.relnr,
	giab.relnr_pch_lbt_pch_nw_ubn,
	giab.geom,
	giab.hfdtype AS bouwjaar
	
	FROM emissie_verdeeld_giab_hist AS verf
		INNER JOIN substances AS s ON s.er_stof_code = verf.stof_code::text
		INNER JOIN giab_hist AS giab USING (ai_code, tle_id)
		INNER JOIN geo_vierkanten AS vk ON st_intersects(vk.geometry, giab.geom)
	
	WHERE 
		verf.emissiejaar = v_year
		AND verf.idg_code::text = v_gcn_sector::text 
		AND verf.stof_code::text = v_stof_code::text
;

END;
$BODY$
LANGUAGE 'plpgsql';
