/*
 * scenarios
 * ---------
 * 
 */
CREATE TABLE scenarios (
	scenario_id integer NOT NULL,
	scenario_naam text NOT NULL,
	omschrijving text NOT NULL,

	CONSTRAINT scenarios_pkey PRIMARY KEY (scenario_id)
);


/*
 * years
 * -----
 * 
 */
CREATE TABLE years (
	year integer NOT NULL,
	year_category year_category_type NOT NULL,
	scenario_id integer NOT NULL,

	CONSTRAINT years_pkey PRIMARY KEY (year, year_category, scenario_id),
	CONSTRAINT years_fkey_scenarios FOREIGN KEY (scenario_id) REFERENCES scenarios
);


/*
 * sectors
 * -------
 * Table containing AERIUS sectors.
 */
CREATE TABLE sectors (
	sector_id integer NOT NULL,
	description text NOT NULL,

	CONSTRAINT sectors_pkey PRIMARY KEY (sector_id)
);


/*
 * gcn_sectors
 * -----------
 * Sectorindeling van het RIVM.
 * Elke GCN-sector is gekoppeld aan een AERIUS-sector. Hierdoor weten we aan welke AERIUS-sector de depositie van de RIVM-bronnen toegekend moet worden).
 */
CREATE TABLE gcn_sectors (
	gcn_sector_id integer NOT NULL,
	sector_id integer NOT NULL,
	description text NOT NULL,
	--er_indeling_code text,
	--er_er_indeling_naam text,

	CONSTRAINT gcn_sectors_pkey PRIMARY KEY (gcn_sector_id),
	CONSTRAINT gcn_sectors_fkey_sectors FOREIGN KEY (sector_id) REFERENCES sectors
);


/*
 * sectorgroups
 * ------------
 * Koppeltabel voor sector en sectorgroep.
 */
CREATE TABLE sectorgroups (
	sector_id integer NOT NULL,
	sectorgroup text NOT NULL,

	CONSTRAINT sectorgroups_pkey PRIMARY KEY (sector_id)
);


/*
 * pbl_sectors
 * -----------
 * Koppeltabel tussen GCN sectoren en de sector indeling die het PlanBureau voor de Leefomgevening hanteert.
 */
CREATE TABLE pbl_sectors (
	gcn_sector_id integer NOT NULL,
	pbl_sector text NOT NULL,

	CONSTRAINT pbl_sectors_pkey PRIMARY KEY (gcn_sector_id),
	CONSTRAINT pbl_sectors_gcn_sectors_fkey_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
);


/*
 * substances
 * ----------
 * De stoffen beschikbaar in de database.
 */
CREATE TABLE substances (
	substance_id smallint NOT NULL,
	substance_name text NOT NULL,
	er_stof_code text NOT NULL,
	er_stof_naam text NOT NULL, 
	gcn_stof_code text NOT NULL,

	CONSTRAINT substances_pkey PRIMARY KEY (substance_id)
);


/*
 * dataset
 * -------
 * De beschikbare datasets/baasename combinaties in de database.
 */
CREATE TABLE dataset (
	dataset_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	dataset_omschrijving text NOT NULL UNIQUE,
	basename_omschrijving text NOT NULL UNIQUE,
	datum_levering date NULL,

	CONSTRAINT dataset_pkey primary key (dataset_id)
);
