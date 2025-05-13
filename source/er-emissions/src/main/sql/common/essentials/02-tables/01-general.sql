/*
 * metadata
 * --------
 * metadata check-tabel waarin van elke tabel in schema public en brn wordt bijgehouden:
 * - @column filename_import De data-versie die is geimporteerd via de load_table functie (welke voor dit doeleinde is uitgebreid met deze functionaliteit).
 * - @column checksum_import De checksum van de tabel na de import, wordt gevuld door functie load_table. Is deze '0', dan bevate de tabel geen data
 * - @column timestamp_import De datum/tijd van de import, wordt gevuld door functie load_table
 * - @column checksum_change De checksum van de tabel na handmatige check (door bv de functies check.checksum_*). Is deze '0', dan bevate de tabel geen data
 * - @column timestamp_checksum_change De datum/tijd van de checksum_change, wordt ook gevuld door de functies check.checksum_*
 * - @column remarks opmerkingen tov de inhoud van de tabel, kan (tot nu toe) alleen handmatig gevuld worden
 * - @column checksum_check Vergelijkt checksum_import en checksum_change en geeft hierop een:
 *		- null (als de vergelijking niet gemaakt kan worden omdat een of beide kolommen [null] bevat iod)
 *		- TRUE (als beide waarden niet null- en indentiek zijn)
 *		- FALSE (als beide waarden niet null zijn en verschillen)	 
 *		Deze kolom wordt on-the-fly gevuld als 1 van de 2 te checken kolommen gewijzigd wordt (door bv checks.checksum_public_brn_tables()). Middels deze
 * 		kolom is te controleren of de inhoud van de tabel is gewijzigd tov de import van de data via de load_table functie.
 */
CREATE TABLE checks.metadata (
	table_name text NOT NULL,
	filename_import text NULL,
	checksum_import bigint NULL,
	timestamp_import text NULL,
	checksum_change bigint NULL,
	timestamp_checksum_change text NULL,
	remarks text NULL,
	checksum_check text GENERATED ALWAYS AS (CASE 
												WHEN 
													checksum_import IS NOT NULL 
													AND checksum_change IS NOT NULL 
													AND (COALESCE(checksum_import::text, '') = COALESCE(checksum_change::text,'')) 
													THEN 'TRUE' 
												WHEN 
													checksum_import IS NOT NULL 
													AND checksum_change IS NOT NULL 
													AND (COALESCE(checksum_import::text, '') <> COALESCE(checksum_change::text,'')) 
													THEN 'FALSE'
												ELSE '[null]' END) STORED,

	CONSTRAINT metadata_pkey PRIMARY KEY (table_name)
);
