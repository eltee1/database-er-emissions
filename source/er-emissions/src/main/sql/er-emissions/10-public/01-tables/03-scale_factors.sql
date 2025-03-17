/*
 * scale_factors
 * -------------
 * 
 */
CREATE TABLE scale_factors (
    year_from year_type NOT NULL,
    year_to year_type NOT NULL,
    gcn_sector_id integer NOT NULL,
    substance_id integer NOT NULL,
    emissie_from double precision NOT NULL,
    emissie_to double precision NOT NULL,
    scale_factor double precision NOT NULL,
    scenario_id integer NOT NULL,

    CONSTRAINT scale_factors_pkey PRIMARY KEY (year_from, year_to, gcn_sector_id, substance_id, scenario_id),
    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances,
    CONSTRAINT scale_factors_fkey_scenarios FOREIGN KEY (scenario_id) REFERENCES scenarios
);
