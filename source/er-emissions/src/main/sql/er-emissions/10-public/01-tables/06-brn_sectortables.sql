/*
 * brn_agriculture
 * ---------------
 * 
 */
CREATE TABLE brn_agriculture (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m real,
    r_m real,
    s_m real,
    dv smallint,
    cat smallint,
    area smallint,
    ps smallint,
    component character varying(5),
    bronomschrijving character varying(120),
    basename character varying(50),
    dataset character varying(450),
    gcn_sector_id integer,
    substance_id smallint,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_agriculture_idx ON brn_agriculture USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_agriculture_geom_idx ON brn_agriculture USING gist(st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_industry
 * ------------
 * 
 */
CREATE TABLE brn_industry (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m real,
    r_m real,
    s_m real,
    dv smallint,
    cat smallint,
    area smallint,
    ps smallint,
    component character varying(5),
    bronomschrijving character varying(120),
    basename character varying(50),
    dataset character varying(450),
    gcn_sector_id integer,
    substance_id smallint,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_industry_idx ON brn_industry USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_industry_geom_idx ON brn_industry USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));

/*
 * brn_other
 * ---------
 * 
 */
CREATE TABLE brn_other (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m real,
    r_m real,
    s_m real,
    dv smallint,
    cat smallint,
    area smallint,
    ps smallint,
    component character varying(5),
    bronomschrijving character varying(120),
    basename character varying(50),
    dataset character varying(450),
    gcn_sector_id integer,
    substance_id smallint,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_other_idx ON brn_other USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_other_geom_idx ON brn_other USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_road_freeway
 * ----------------
 * 
 */
CREATE TABLE brn_road_freeway (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m real,
    r_m real,
    s_m real,
    dv smallint,
    cat smallint,
    area smallint,
    ps smallint,
    component character varying(5),
    bronomschrijving character varying(120),
    basename character varying(50),
    dataset character varying(450) ,
    gcn_sector_id integer,
    substance_id smallint,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_road_freeway_idx ON brn_road_freeway USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_road_freeway_geom_idx ON brn_road_freeway USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_road_transportation
 * -----------------------
 * 
 */
CREATE TABLE brn_road_transportation (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m real,
    r_m real,
    s_m real,
    dv smallint,
    cat smallint,
    area smallint,
    ps smallint,
    component character varying(5),
    bronomschrijving character varying(120),
    basename character varying(50),
    dataset character varying(450),
    gcn_sector_id integer,
    substance_id smallint,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_road_transportation_idx ON brn_road_transportation USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_road_transportation_geom_idx ON brn_road_transportation USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_shipping
 * ------------
 * 
 */
CREATE TABLE brn_shipping
(
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m real,
    r_m real,
    s_m real,
    dv smallint,
    cat smallint,
    area smallint,
    ps smallint,
    component character varying(5),
    bronomschrijving character varying(120),
    basename character varying(50),
    dataset character varying(450),
    gcn_sector_id integer,
    substance_id smallint,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_shipping_idx ON brn_shipping USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_shipping_geom_idx ON brn_shipping USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));
