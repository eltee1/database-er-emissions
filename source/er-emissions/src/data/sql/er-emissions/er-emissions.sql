--laad de parent-tabellen in

--sectoren
BEGIN; SELECT system.load_table('sectors', '{data_folder}/sectors_export-m25-er-verdeling.txt', TRUE, TRUE); COMMIT;
BEGIN; SELECT system.load_table('gcn_sectors', '{data_folder}/gcn_sectors_export-m25-er-verdeling.txt', TRUE, TRUE); COMMIT;
BEGIN; SELECT system.load_table('sectorgroups', '{data_folder}/sectorgroups_export-m25-er-verdeling.txt', TRUE, TRUE); COMMIT;
BEGIN; SELECT system.load_table('pbl_sectors', '{data_folder}/pbl_sectors_20241025.txt', TRUE, TRUE); COMMIT;
