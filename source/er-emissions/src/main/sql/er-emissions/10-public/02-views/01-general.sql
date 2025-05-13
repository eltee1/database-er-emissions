/*
 * verfijnde_emissies_geregionaliseerd_view
 * ----------------------------------------
 * View die
 */
CREATE OR REPLACE VIEW verfijnde_emissies_geregionaliseerd_view AS
SELECT 
   tle_id,
   ai_code,
   substance_id,
   gcn_stof_code,
   er_stof_code,
   gcn_sector_id,
   emissiejaar,
   emissie_kg,
   geometry

   FROM er_emissie_verfijnd AS em
      INNER JOIN substances USING (er_stof_code)
      INNER JOIN geo_verfijnd USING (tle_id, ai_code)
;

/*
 * vierkanten_emissies_geregionaliseerd_view
 * -----------------------------------------
 * View die (zit ook SO2 en PM10)
 */
CREATE OR REPLACE VIEW vierkanten_emissies_geregionaliseerd_view AS
SELECT 
   em.tle_id,
   em.ai_code,
   substances.substance_id,
   substances.gcn_stof_code,
   em.er_stof_code,
   em.gcn_sector_id,
   em.emissiejaar,
   em.emissie_kg,
   geo_vierkanten.geometry

   FROM er_emissie_vierkanten AS em
      INNER JOIN substances USING (er_stof_code)
      INNER JOIN geo_vierkanten USING (tle_id, ai_code)
;


/*
 * source_characteristics_view
 * ---------------------------
 * View die
 */
CREATE OR REPLACE VIEW source_characteristics_view AS
SELECT 
   gcn_sector_id,
   substance_id,
   heat_content,
   height,
   spread,
   emission_diurnal_variation_id,
   particle_size_distribution,
   code AS diurnal_variation_code

   FROM gcn_sector_source_characteristics
      LEFT JOIN emission_diurnal_variations USING (emission_diurnal_variation_id)
;
