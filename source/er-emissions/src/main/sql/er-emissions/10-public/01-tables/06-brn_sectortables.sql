/*
 * brn_agriculture_m26
 * -------------------
 * 
 */
CREATE TABLE brn_agriculture_m26 (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m double precision,
    r_m bigint,
    s_m double precision,
    dv bigint,
    cat bigint,
    area bigint,
    ps bigint,
    component character varying(3),
    bronomschrijving character varying(110),
    gcn_sector_id integer,
    substance_id smallint,
    dataset_id integer,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_agriculture_idx ON brn_agriculture_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_agriculture_geom_idx ON brn_agriculture_m26 USING gist(st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_industry_m26
 * ----------------
 * 
 */
CREATE TABLE brn_industry_m26 (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m double precision,
    r_m bigint,
    s_m double precision,
    dv bigint,
    cat bigint,
    area bigint,
    ps bigint,
    component character varying(3),
    bronomschrijving character varying(110),
    gcn_sector_id integer,
    substance_id smallint,
    dataset_id integer,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_industry_idx ON brn_industry_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_industry_geom_idx ON brn_industry_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_other_m26
 * -------------
 * 
 */
CREATE TABLE brn_other_m26 (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m double precision,
    r_m bigint,
    s_m double precision,
    dv bigint,
    cat bigint,
    area bigint,
    ps bigint,
    component character varying(3),
    bronomschrijving character varying(110),
    gcn_sector_id integer,
    substance_id smallint,
    dataset_id integer,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_other_idx ON brn_other_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_other_geom_idx ON brn_other_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_road_freeway_m26
 * --------------------
 * 
 */
CREATE TABLE brn_road_freeway_m26 (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m double precision,
    r_m bigint,
    s_m double precision,
    dv bigint,
    cat bigint,
    area bigint,
    ps bigint,
    component character varying(3),
    bronomschrijving character varying(110),
    gcn_sector_id integer,
    substance_id smallint,
    dataset_id integer,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_road_freeway_idx ON brn_road_freeway_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_road_freeway_geom_idx ON brn_road_freeway_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_road_transportation_m26
 * ---------------------------
 * 
 */
CREATE TABLE brn_road_transportation_m26 (
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m double precision,
    r_m bigint,
    s_m double precision,
    dv bigint,
    cat bigint,
    area bigint,
    ps bigint,
    component character varying(3),
    bronomschrijving character varying(110),
    gcn_sector_id integer,
    substance_id smallint,
    dataset_id integer,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_road_transportation_idx ON brn_road_transportation_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_road_transportation_geom_idx ON brn_road_transportation_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * brn_shipping_m26
 * ----------------
 * 
 */
CREATE TABLE brn_shipping_m26
(
    snr bigint,
    x_m bigint,
    y_m bigint,
    q_g_s double precision,
    hc_mw double precision,
    h_m double precision,
    r_m bigint,
    s_m double precision,
    dv bigint,
    cat bigint,
    area bigint,
    ps bigint,
    component character varying(3),
    bronomschrijving character varying(110),
    gcn_sector_id integer,
    substance_id smallint,
    dataset_id integer,

    CONSTRAINT scale_factors_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT scale_factorss_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_shipping_idx ON brn_shipping_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_shipping_geom_idx ON brn_shipping_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));
