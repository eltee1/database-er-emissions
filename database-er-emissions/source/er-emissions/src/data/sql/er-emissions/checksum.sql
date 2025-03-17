--vul de checksum_hash kolommen voor alle tabelnamen in de tabel metadata, na de build wordt dit geregeld door de triggers die op
--alle tabellen in het public-schema komen.
SELECT system.fill_metadata_checksum();
