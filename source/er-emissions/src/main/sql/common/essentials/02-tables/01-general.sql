/*
 * metadata
 * --------
 * Metadata- tabel waarin van elke tabel in de database (schema public) wordt bijgehouden:
 * - welke data-versie is geimporteerd (@column filename_import)
 * - de checksum van de tabel na de import (@column checksum_import), wordt alleen door gebruik van de functie load_table (welke voor dit doeleinde is uitgebreid met deze functionaliteit)
 * - wanneer deze import heeft plaatsgevonden (@column timestamp_import) wordt gevuld door de functie load_table.
 * - de checksum van de tabel na een eventuele wijziging (@column checksum_change), wordt on demand gevuld door de functies system.checksum_metadata() en system.checksum_public_tables(). Middels deze
 * kolom is te controleren of de inhoud van de tabel is gewijzigd tov de import van de data via de load_table functie.
 * - wanneer de checksum_change heeft plaatsgevonden (@column timestamp_checksum_change)
 * - opmerkingen tov de inhoud van de taberl (@column remarks)
 */
CREATE TABLE metadata (
	table_name text NOT NULL,
	filename_import text NULL,
	checksum_import bigint NULL,
	timestamp_import text NULL,
	checksum_change bigint NULL,
	timestamp_checksum_change text NULL,
	remarks text NULL,

	CONSTRAINT metadata_pkey PRIMARY KEY (table_name)
);
