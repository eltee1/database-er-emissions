/*
 * build_aggregated_brn_road_freeway_final
 * ---------------------------------------------
 * Functie die per groupid de tabel agg_aggregated_brn_road_freeway_final vult met de juiste data.
 * 
 */
CREATE OR REPLACE FUNCTION freeway.build_aggregated_brn_road_freeway_final(v_groupid integer)
	RETURNS VOID
AS 
$BODY$
DECLARE 
	sql text;
BEGIN
	sql:= 
		'WITH agg_grid_to_brn_road_freeway AS (
		SELECT 
			snr,
			CASE WHEN grid_center_x = 0 THEN x_m ELSE grid_center_x
				END AS x_m,
			CASE WHEN grid_center_y = 0 THEN y_m ELSE grid_center_y
				END AS y_m,
			q_g_s,
			gcn_sector_id,
			substance_id,
			groupid,
			grid_size_id,
			CASE WHEN grid_size_id = 1 THEN 0 ELSE sqrt(ST_area(grid.geom))
				END AS r_m,
			grid_id,
			grid_n2k_cluster_id
					
		FROM freeway.agg_grid_n2k_clusters AS grid
			INNER JOIN freeway.aerius_mxx_brn_road_freeway AS brn ON st_intersects(grid.geom, brn.geom)
		WHERE groupid = '||v_groupid||'
		),
		agg_aggregated_brn_road_freeway AS (
			SELECT 
				min(snr) AS snr,
				x_m,
				y_m,
				sum(q_g_s) AS q_g_s,
				gcn_sector_id,
				substance_id,
				groupid,
				grid_size_id,
				r_m,
				min(grid_n2k_cluster_id) AS grid_n2k_cluster_id
			
			FROM agg_grid_to_brn_road_freeway
		
		GROUP BY groupid, grid_size_id, grid_id, gcn_sector_id, substance_id, r_m, x_m, y_m
		
		ORDER BY grid_size_id, gcn_sector_id, substance_id
		)
		INSERT INTO freeway.agg_aggregated_brn_road_freeway_final
			(snr, x_m, y_m, q_g_s, gcn_sector_id, substance_id, groupid, grid_size_id, r_m, grid_n2k_cluster_id)
		
		SELECT * FROM agg_aggregated_brn_road_freeway
		;
	';

EXECUTE sql;

END;
	
$BODY$
LANGUAGE plpgsql VOLATILE;

COMMENT ON FUNCTION freeway.build_aggregated_brn_road_freeway_final IS 'Functie die per groupid de tabel agg_aggregated_brn_road_freeway_final vult met de juiste data.';
