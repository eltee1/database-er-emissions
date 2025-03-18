/*
 * aerius_mxx_brn_road_freeway
 * ---------------------------
 * Tabel waarin de road_freeway emissies staan, mxx wordt gebruikt omdat dit generiek is voor elke Monitor-versie.
 *
 */
CREATE TABLE IF NOT EXISTS aerius_mxx_brn_road_freeway (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    gcn_sector_id integer,
    substance_id smallint,
    brn_road_freeway_id integer,

    CONSTRAINT aerius_mxx_brn_road_freeway_pkey PRIMARY KEY (brn_road_freeway_id)
);


/*
 * agg_grid_n2k_clusters
 * ---------------------
 * Tabel met daarin de n2000 grid clusters.
 *
 */
CREATE TABLE IF NOT EXISTS agg_grid_n2k_clusters (
    groupid bigint,
    buffer_id bigint,
    grid_size_id bigint,
    grid_id bigint,
    grid_center_x bigint,
    grid_center_y bigint,
    geom geometry(Geometry,28992),
    grid_n2k_cluster_id integer,

    CONSTRAINT agg_grid_n2k_clusters_pkey PRIMARY KEY (grid_n2k_cluster_id)
);

ALTER TABLE agg_grid_n2k_clusters ALTER COLUMN geom SET STORAGE EXTERNAL;

CREATE INDEX IF NOT EXISTS agg_grid_n2k_clusters_geom_idx ON agg_grid_n2k_clusters USING GIST (geom);
CREATE INDEX IF NOT EXISTS agg_grid_n2k_clusters_cluster_id_idx ON agg_grid_n2k_clusters USING btree (grid_n2k_cluster_id);


/*
 * agg_aggregated_brn_road_freeway_final
 * -------------------------------------
 * Eindtabel agg_aggregated_brn_road_freeway_final. Hierin komt data van agg_grid_n2k_clusters en aerius_mxx_brn_road_freeway samen, 
 * gelinkt door de tussen-child tabel grid_n2k_clusters_to_brn_road_freeway_groupid_xx.
 * Er komen nog geen pkey of indexen op ivm de snelheid van vullen van deze tabel.
 * Na de insert wordt er een index gezet op grid_size_id; pk is waarschijnlijk niet nodig.
 *
 */
CREATE TABLE IF NOT EXISTS freeway.agg_aggregated_brn_road_freeway_final (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    gcn_sector_id integer,
    substance_id smallint,
    groupid bigint,
    grid_size_id bigint,
    r_m bigint, 
    grid_n2k_cluster_id integer
);


/*
 * temp_groupids
 * -------------
 * Temp-tabel met alle groupids, wordt gebruikt tijdens de build voor de multithread.
 * Schijnbaar kan er geen DISTINCT select worden gebruikt bij selecteren van id's, deze tabel komt daarvoor in de plaats.
 *
 */
CREATE TABLE IF NOT EXISTS temp_groupids (
    groupid bigint
);
