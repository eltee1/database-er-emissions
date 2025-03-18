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
 * check_totals_view
 * -----------------
 * View die
 */ 
CREATE OR REPLACE VIEW check_totals_view AS
SELECT 
   emissiejaar,
   gcn_sector_id,
   er_stof_code,
   substance_id,
   gcn_stof_code,
   em_nt,
   em_reg,
   (em_nt - em_reg) AS verschil

   FROM 
      (SELECT 
         emissiejaar,
         er_stof_code,
         LEFT(er_indeling_code, 4)::integer AS gcn_sector_id,
         ROUND(emissie_kg::numeric, 3) AS em_nt
      
         FROM er_emissie_nationaal_erc
      ) AS nt

      INNER JOIN 
         (SELECT 
            emissiejaar,
            gcn_sector_id,
            er_stof_code,
            ROUND(sum(emissie_kg)::numeric, 3) AS em_reg
         
            FROM verfijnde_emissies_geregionaliseerd_view
            
            GROUP BY emissiejaar, gcn_sector_id, er_stof_code
         ) AS reg USING (emissiejaar, gcn_sector_id, er_stof_code)
   
      INNER JOIN substances USING (er_stof_code)
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
