-- Inladen data
BEGIN; SELECT system.load_table('shipping.mxx_brn_shipping', '{data_folder}/load/m25_brn_shipping_export_20250707.csv', TRUE, FALSE); COMMIT;
BEGIN; SELECT system.load_table('shipping.agg_grid_n2k_clusters', '{data_folder}/load/agg_grid_n2k_clusters_20250707.csv', TRUE, FALSE); COMMIT;

-- Maak de geom kolom aan in aerius_mxx_brn_shipping
BEGIN; ALTER TABLE shipping.mxx_brn_shipping ADD COLUMN geom geometry; COMMIT;

-- Zet de storage van de geom kolom inv mxx_brn_shipping op EXTERNAL
BEGIN; ALTER TABLE shipping.mxx_brn_shipping ALTER COLUMN geom SET STORAGE EXTERNAL; COMMIT;

-- Vul geometry kolom van mxx_brn_shipping
SELECT ae_raise_notice('Vul de geom-kolom in aerius_mxx_brn_shipping @ ' || timeofday());
BEGIN; 
	UPDATE shipping.mxx_brn_shipping
		SET geom = st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992);
COMMIT;

-- Zet een index op geometry kolom in mxx_brn_shipping
SELECT ae_raise_notice('Zet een GIST-index op kolom geom in shipping.mxx_brn_shipping @ ' || timeofday());
BEGIN; CREATE INDEX idx_mxx_brn_shipping_gist ON shipping.mxx_brn_shipping USING GIST (geom); COMMIT;

-- Workaround om de multithread werkend te krijgen: temp-tabel maken met alle groupid's. schijnbaar kan er geen DISTINCT select worden gebruikt bij selecteren van id's.
SELECT ae_raise_notice('Vul temp- tabel voor de groupids: temp_groupids @ ' || timeofday());
BEGIN; INSERT INTO shipping.temp_groupids (groupid) SELECT DISTINCT groupid FROM shipping.agg_grid_n2k_clusters ORDER BY groupid; COMMIT;
