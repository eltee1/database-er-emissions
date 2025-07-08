/*
 * mxx_brn_shipping
 * ----------------
 * Tabel waarin de shipping emissies staan, mxx wordt gebruikt omdat dit generiek is voor elke Monitor-versie.
 *
 */
CREATE TABLE shipping.mxx_brn_shipping (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    gcn_sector_id integer,
    substance_id smallint,
    brn_shipping_id integer,

    CONSTRAINT mxx_brn_shipping_pkey PRIMARY KEY (brn_shipping_id)
);


/*
 * agg_grid_n2k_clusters
 * ---------------------
 * Tabel met daarin de n2000 grid clusters.
 *
 */
CREATE TABLE shipping.agg_grid_n2k_clusters (
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

ALTER TABLE shipping.agg_grid_n2k_clusters ALTER COLUMN geom SET STORAGE EXTERNAL;

CREATE INDEX agg_grid_n2k_clusters_geom_idx ON shipping.agg_grid_n2k_clusters USING GIST (geom);
CREATE INDEX agg_grid_n2k_clusters_cluster_id_idx ON shipping.agg_grid_n2k_clusters USING btree (grid_n2k_cluster_id);


/*
 * agg_aggregated_brn_shipping_final
 * ---------------------------------
 * Eindtabel agg_aggregated_brn_shipping_final. Hierin komt data van agg_grid_n2k_clusters en mxx_brn_shipping samen, 
 * gelinkt door de tussen-child tabel grid_n2k_clusters_to_brn_shipping_groupid_xx.
 * Er komen nog geen pkey of indexen op ivm de snelheid van vullen van deze tabel.
 * Na de insert wordt er een index gezet op grid_size_id; pk is waarschijnlijk niet nodig.
 *
 */
CREATE TABLE shipping.agg_aggregated_brn_shipping_final (
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
CREATE TABLE shipping.temp_groupids (
    groupid bigint
);
