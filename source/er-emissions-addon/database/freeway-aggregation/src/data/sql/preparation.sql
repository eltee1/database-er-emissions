/*1. In de juiste mxx-er-emissie database (op het aerius-cluster) waarvoor de aggregatie moet worden uitgevoerd, moeten unieke id-kolommen worden toegevoegd aan de tabellen agg_grid_n2k_clusters en aerius_mxx_brn_road_freeway.*/
	ALTER TABLE agg_grid_n2k_clusters 
	        ADD COLUMN grid_n2k_cluster_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY;
	        
	ALTER TABLE aerius_m26_brn_road_freeway -- hier mxx aanpassen naar het juiste jaar!
	        ADD COLUMN brn_road_freeway_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY; 


/*2. Qua performance is het veel beter om alleen de benodigde kolommen van de tabel aerius_mxx_brn_road_freeway te exporteren vanaf het cluster. Onderstaande query maakt een nieuwe tabel aan 
	"aerius_mxx_brn_road_freeway_export" met daarin alleen de benodigde kolommen, deze moet geexporteerd worden naar de locatie waar de tussentabellen gegenereerd gaan worden. Op deze locatie zal de export-file 
	door de addon-build worden geimporteerd in de tabel aerius_mxx_brn_road_freeway.*/

	SELECT 
		snr, 
		x_m,
		y_m,
		q_g_s,
		gcn_sector_id,
		substance_id,
		brn_road_freeway_id

	INTO aerius_m26_brn_road_freeway_export -- hier mxx aanpassen naar het juiste jaar!
	FROM aerius_m26_brn_road_freeway -- hier mxx aanpassen naar het juiste jaar!
;


/*3. Exporteer de twee tabellen aerius_mxx_brn_road_freeway_export en agg_grid_n2k_clusters naar de lokale machine vanuit waar de aggregatie wordt uitgevoerd, zet deze in 'dbdata/er-emissions/load/' .*/ 
