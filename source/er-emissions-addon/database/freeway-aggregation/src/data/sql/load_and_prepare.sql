-- Inladen data
BEGIN; SELECT system.load_table('freeway.aerius_mxx_brn_road_freeway', '{data_folder}/m25_brn_road_freeway_export_20241206.csv', FALSE, FALSE); COMMIT;
BEGIN; SELECT system.load_table('freeway.agg_grid_n2k_clusters', '{data_folder}/agg_grid_n2k_clusters_20241119.csv', FALSE, FALSE); COMMIT;

-- Maak de geom kolom aan in aerius_mxx_brn_road_freeway
BEGIN; ALTER TABLE freeway.aerius_mxx_brn_road_freeway ADD COLUMN geom geometry; COMMIT;

-- Zet de storage van de geom kolom in aerius_mxx_brn_road_freeway op EXTERNAL
BEGIN; ALTER TABLE freeway.aerius_mxx_brn_road_freeway ALTER COLUMN geom SET STORAGE EXTERNAL; COMMIT;

-- Vul geometry kolom van aerius_mxx_brn_road_freeway
SELECT ae_raise_notice('Vul de geom-kolom in aerius_mxx_brn_road_freeway @ ' || timeofday());
BEGIN; 
	UPDATE freeway.aerius_mxx_brn_road_freeway 
		SET geom = st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992);
COMMIT;

-- Zet een index op geometry kolom in aerius_mxx_brn_road_freeway
SELECT ae_raise_notice('Zet een GIST-index op kolom geom in freeway.aerius_mxx_brn_road_freeway @ ' || timeofday());
BEGIN; CREATE INDEX idx_aerius_mxx_brn_road_freeway_gist ON freeway.aerius_mxx_brn_road_freeway USING GIST (geom); COMMIT;

-- Workaround om de multithread werkend te krijgen: temp-tabel maken met alle groupid's. schijnbaar kan er geen DISTINCT select worden gebruikt bij selecteren van id's.
SELECT ae_raise_notice('Vul temp- tabel voor de groupids: temp_groupids @ ' || timeofday());
BEGIN; INSERT INTO freeway.temp_groupids (groupid) SELECT DISTINCT groupid FROM freeway.agg_grid_n2k_clusters ORDER BY groupid; COMMIT;
