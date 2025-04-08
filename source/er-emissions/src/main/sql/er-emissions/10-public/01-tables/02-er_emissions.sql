/*
 * er_emissie_nationaal_erc
 * ------------------------
 * 
 */
CREATE TABLE er_emissie_nationaal_erc (
	dataset_id  integer NOT NULL,
	emissiejaar int NOT NULL,
	er_stof_code text NOT NULL,
	er_indeling_code text NOT NULL, 
	ind_erc text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_nationaal_erc_pkey PRIMARY KEY (dataset_id, emissiejaar, er_stof_code, er_indeling_code, ind_erc)
 );


/*
 * er_emissie_nationaal_eri
 * ------------------------
 * 
 */ 
CREATE TABLE er_emissie_nationaal_eri (
	dataset_id integer NOT NULL,
	emissiejaar int NOT NULL,
	er_stof_code text NOT NULL,
	er_indeling_code text NOT NULL, 
	ind_erc text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_nationaal_eri_pkey PRIMARY KEY (dataset_id, emissiejaar, er_stof_code, er_indeling_code, ind_erc)
 );


/*
 * er_emissie_per_emissieoorzaak
 * -----------------------------
 * 
 */ 
CREATE TABLE er_emissie_per_emissieoorzaak (
	dataset_id integer NOT NULL,
	er_indeling_naam text NOT NULL,
	emissiejaar integer NOT NULL,
	emissieoorzaak_code text NOT NULL,
	proces_omschrijving text NOT NULL,
	er_indeling_code text NOT NULL, 
	er_stof_code text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_per_emissieoorzaak_pkey PRIMARY KEY (dataset_id, er_indeling_naam, emissiejaar, emissieoorzaak_code, proces_omschrijving, er_indeling_code, er_stof_code)
 );
 

/*
 * emissieoorzaken
 * ---------------
 * 
 */ 
CREATE TABLE emissieoorzaken ( 
	emissieoorzaak_code text NOT NULL,
	proces_omschrijving text NOT NULL,
	gcn_sector_id integer NOT NULL,
	dataset_id integer NOT NULL,

	CONSTRAINT emissieoorzaken_pkey PRIMARY KEY (emissieoorzaak_code),
	CONSTRAINT emissieoorzaken_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
  );


/*
 * er_emissie_vierkanten
 * ---------------------
 * 
 */ 
CREATE TABLE er_emissie_vierkanten (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	emissiejaar integer NOT NULL,
	gcn_sector_id integer NOT NULL,
	er_stof_code text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_vierkanten_pkey PRIMARY KEY (tle_id),
	CONSTRAINT er_emissie_vierkanten_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
 );


/*
 * er_emissie_verfijnd
 * -------------------
 * 
 */ 
CREATE TABLE er_emissie_verfijnd (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	emissiejaar integer NOT NULL,
	gcn_sector_id integer NOT NULL,
	er_stof_code text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_verfijnd_pkey PRIMARY KEY (tle_id),
	CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
 );

CREATE UNIQUE INDEX idx_er_emissie_verfijnd_1 ON er_emissie_verfijnd (ai_code, tle_id, gcn_sector_id, er_stof_code, emissiejaar);
CREATE INDEX idx_er_emissie_verfijnd_2 ON er_emissie_verfijnd (ai_code, tle_id);


/*
 * er_emissie_individueel
 * ----------------------
 * 
 */ 
CREATE TABLE er_emissie_individueel (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	emissiejaar integer NOT NULL,
	gcn_sector_id integer NOT NULL,
	er_stof_code text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_individueel_pkey PRIMARY KEY (tle_id),
	CONSTRAINT er_emissie_individueel_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
 );


/*
 * er_emissie_vliegvelden
 * ----------------------
 * 
 */ 
CREATE TABLE er_emissie_vliegvelden (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	emissiejaar integer NOT NULL,
	gcn_sector_id integer NOT NULL,
	er_stof_code text NOT NULL,
	emissie_kg double precision NOT NULL,

	CONSTRAINT er_emissie_vliegvelden_pkey PRIMARY KEY (tle_id),
	CONSTRAINT er_emissie_vliegvelden_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
 );


/*
 * emissie_totalen
 * ---------------
 * 
 */ 
CREATE TABLE emissie_totalen (
    dataset_id integer NOT NULL,
    gcn_sector_id integer NOT NULL,
    substance_id integer NOT NULL,
    jaar integer NOT NULL,
    emissie_kg double precision NOT NULL,

    CONSTRAINT emissie_totalen_pkey PRIMARY KEY (dataset_id),
    --CONSTRAINT emissie_totalen_fkey_dataset FOREIGN KEY (dataset_id) REFERENCES dataset,
    CONSTRAINT emissie_totalen_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances,
    CONSTRAINT emissie_totalen_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors
);
