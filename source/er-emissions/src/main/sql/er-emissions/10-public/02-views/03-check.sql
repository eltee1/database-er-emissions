/*
 * check_totals_view
 * -----------------
 * View die
 */ 
CREATE OR REPLACE VIEW checks.check_totals_view AS
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
 * check_totals_vk_view
 * --------------------
 * View die
 */ 
CREATE OR REPLACE VIEW checks.check_totals_vk_view AS
SELECT 
   nt.emissiejaar,
   nt.gcn_sector_id,
   nt.er_stof_code,
   nt.em_nt,
   reg.em_reg,
   nt.em_nt - reg.em_reg AS verschil,
   ROUND((nt.em_nt - reg.em_reg + 0.001) / (nt.em_nt + 0.001), 4) AS verschil_percentage
   
   FROM ( 
      SELECT 
         emissiejaar,
         er_stof_code,
         LEFT(er_indeling_code, 4)::integer AS gcn_sector_id,
         ROUND(emissie_kg::numeric, 3) AS em_nt

         FROM er_emissie_nationaal_erc) AS nt
   
   INNER JOIN ( 
      SELECT 
         emissiejaar,
         gcn_sector_id,
         er_stof_code,
         ROUND(SUM(emissie_kg)::numeric, 3) AS em_reg

         FROM vierkanten_emissies_geregionaliseerd_view
         
         GROUP BY emissiejaar, gcn_sector_id, er_stof_code
      ) AS reg 
      USING (emissiejaar, gcn_sector_id, er_stof_code)

   ORDER BY nt.gcn_sector_id, nt.er_stof_code
;


/*
 * check_totals_sn_view
 * --------------------
 * View die
 */ 
CREATE OR REPLACE VIEW checks.check_totals_sn_view AS
SELECT 
   gcn_sector_id,
   brn.substance_id,
   brn.component,
   brn.q_g_s,
   brn.q_g_s / 1000::double precision * (60 * 60 * 24 * 365)::double precision AS emissie_kg

   FROM (
      SELECT 
         gcn_sector_id,
         substance_id,
         component,
         SUM(q_g_s) AS q_g_s
      
         FROM brn.agriculture_m26
      
         GROUP BY gcn_sector_id, substance_id, component
      
      UNION ALL
      
      SELECT 
         gcn_sector_id,
         substance_id,
         component,
         SUM(q_g_s) AS q_g_s
        
         FROM brn.other_m26
      
         GROUP BY gcn_sector_id, substance_id, component
     
      UNION ALL
        
      SELECT 
         gcn_sector_id,
         substance_id,
         component,
         SUM(q_g_s) AS q_g_s

         FROM brn.industry_m26
         
         GROUP BY gcn_sector_id, substance_id, component
      
      UNION ALL
      
      SELECT

         gcn_sector_id,
         substance_id,
         component,
         SUM(q_g_s) AS q_g_s

         FROM brn.road_freeway_m26
      
         GROUP BY gcn_sector_id, substance_id, component

      UNION ALL

      SELECT 
         gcn_sector_id,
         substance_id,
         component,
         SUM(q_g_s) AS q_g_s

         FROM brn.road_transportation_m26
         
         GROUP BY gcn_sector_id, substance_id, component

      UNION ALL
      
      SELECT
         gcn_sector_id,
         substance_id,
         component,
         SUM(q_g_s) AS q_g_s

         FROM brn.shipping_m26
         GROUP BY gcn_sector_id, substance_id, component) AS brn
;
