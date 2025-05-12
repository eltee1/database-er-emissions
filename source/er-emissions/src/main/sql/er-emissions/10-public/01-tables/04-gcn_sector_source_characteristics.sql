/*
 * gcn_sector_source_characteristics
 * ---------------------------------
 * 
 */
CREATE TABLE gcn_sector_source_characteristics (
	gcn_sector_id integer NOT NULL,
	substance_id smallint NOT NULL,
	heat_content real NOT NULL,
	height real NOT NULL,
	spread real NOT NULL,
	emission_diurnal_variation_id integer NOT NULL,
	particle_size_distribution integer NOT NULL,

	CONSTRAINT gcn_sector_source_characteristics_pkey PRIMARY KEY (gcn_sector_id, substance_id),
	CONSTRAINT gcn_sector_source_characteristics_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES public.gcn_sectors (gcn_sector_id),
	CONSTRAINT gcn_sector_source_characteristics_fkey_gcn_substances FOREIGN KEY (substance_id) REFERENCES public.substances (substance_id) 
);


/*
 * emission_diurnal_variations
 * ---------------------------
 * 
 */
CREATE TABLE emission_diurnal_variations (
	emission_diurnal_variation_id integer  NOT NULL,
	code text NOT NULL,
	name text NOT NULL,
	description text NOT NULL,

	CONSTRAINT emission_diurnal_variations_pkey PRIMARY KEY (emission_diurnal_variation_id)
);
