/*
 * brn_agriculture_view
 * --------------------
 * View die de data terugeeft uit brn_agriculturey, aangevuld met de bron-, dataset- en basename omschrijvingen ipv de id's.
 */
CREATE OR REPLACE VIEW brn_agriculture_view AS
SELECT 
	snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
	dataset.dataset_omschrijving as dataset, basename.basename_omschrijving as basename
	
FROM brn_agriculture
	INNER JOIN dataset USING (dataset_id)
	INNER JOIN basename USING (basename_id)
	INNER JOIN bron USING (bron_id)
;


/*
 * brn_industry_view
 * -----------------
 * View die de data terugeeft uit brn_industry, aangevuld met de bron-, dataset- en basename omschrijvingen ipv de id's.
 */
CREATE OR REPLACE VIEW brn_industry_view AS
SELECT 
	snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
	dataset.dataset_omschrijving as dataset, basename.basename_omschrijving as basename
	
FROM brn_industry AS base
	INNER JOIN dataset USING (dataset_id)
	INNER JOIN basename USING (basename_id)
	INNER JOIN bron USING (bron_id)
;


/*
 * brn_other_view
 * --------------
 * View die de data terugeeft uit brn_other, aangevuld met de bron-, dataset- en basename omschrijvingen ipv de id's.
 */
CREATE OR REPLACE VIEW brn_other_view AS
SELECT 
	snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
	dataset.dataset_omschrijving as dataset, basename.basename_omschrijving as basename
	
FROM brn_other
	INNER JOIN dataset USING (dataset_id)
	INNER JOIN basename USING (basename_id)
	INNER JOIN bron USING (bron_id)
;


/*
 * brn_road_freeway_view
 * ---------------------
 * View die de data terugeeft uit brn_road_freeway, aangevuld met de bron-, dataset- en basename omschrijvingen ipv de id's.
 */
CREATE OR REPLACE VIEW brn_road_freeway_view AS
SELECT 
	snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
	dataset.dataset_omschrijving as dataset, basename.basename_omschrijving as basename
	
FROM brn_road_freeway
	INNER JOIN dataset USING (dataset_id)
	INNER JOIN basename USING (basename_id)
	INNER JOIN bron USING (bron_id)
;


/*
 * brn_road_transportation_view
 * ----------------------------
 * View die de data terugeeft uit brn_road_transportation, aangevuld met de bron-, dataset- en basename omschrijvingen ipv de id's.
 */
CREATE OR REPLACE VIEW brn_road_transportation_view AS
SELECT 
	snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
	dataset.dataset_omschrijving as dataset, basename.basename_omschrijving as basename
	
FROM brn_road_transportation
	INNER JOIN dataset USING (dataset_id)
	INNER JOIN basename USING (basename_id)
	INNER JOIN bron USING (bron_id)
;


/*
 * brn_shipping_view
 * -----------------
 * View die de data terugeeft uit brn_shipping, aangevuld met de bron-, dataset- en basename omschrijvingen ipv de id's.
 */
CREATE OR REPLACE VIEW brn_shipping_view AS
SELECT 
	snr, x_m, y_m, q_g_s, hc_mw, h_m, r_m, s_m, dv, cat, area, ps, component, bron.bron_omschrijving as bronomschrijving, gcn_sector_id, substance_id, 
	dataset.dataset_omschrijving as dataset,
	basename.basename_omschrijving as basename
	
FROM brn_shipping
	INNER JOIN dataset USING (dataset_id)
	INNER JOIN basename USING (basename_id)
	INNER JOIN bron USING (bron_id)
;
