/*
 * metadata
 * --------
 * Metadata- tabel waarin wordt bijgehouden welke data-versie in elke tabel in de database staat, wordt gevuld door een versie van de functie load_table, welke 
 * is uitgebreid met het wegschrijven van de ingeladen tabel in de metadata- tabel.
 */
CREATE TABLE metadata (
	table_name text NOT NULL,
	filename text NOT NULL,
	timestamp_import text DEFAULT to_char(clock_timestamp(), 'DD-MM-YYYY HH24:MI:SS.MS'),
	checksum_import bigint NULL,
	checksum_change bigint NULL,
	remarks text NULL,

	CONSTRAINT metadata_pkey PRIMARY KEY (table_name)
);
