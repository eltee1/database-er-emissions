/*
 * agriculture_m26
 * ---------------
 * 
 */
CREATE TABLE brn.agriculture_m26 (
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
    bnrset_id integer,

    CONSTRAINT agriculture_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT agriculture_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS agriculture_idx ON brn.agriculture_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS agriculture_geom_idx ON brn.agriculture_m26 USING gist(st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * industry_m26
 * ------------
 * 
 */
CREATE TABLE brn.industry_m26 (
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
    bnrset_id integer,

    CONSTRAINT industry_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT industry_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS industry_idx ON brn.industry_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS industry_geom_idx ON brn.industry_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * other_m26
 * ---------
 * 
 */
CREATE TABLE brn.other_m26 (
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
    bnrset_id integer,

    CONSTRAINT other_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT other_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS brn_other_idx ON brn.other_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS brn_other_geom_idx ON brn.other_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * road_freeway_m26
 * ----------------
 * 
 */
CREATE TABLE brn.road_freeway_m26 (
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
    bnrset_id integer,

    CONSTRAINT road_freeway_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT road_freeway_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS road_freeway_idx ON brn.road_freeway_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS road_freeway_geom_idx ON brn.road_freeway_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * road_transportation_m26
 * -----------------------
 * 
 */
CREATE TABLE brn.road_transportation_m26 (
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
    bnrset_id integer,

    CONSTRAINT road_transportation_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT road_transportation_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS road_transportation_idx ON brn.road_transportation_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS road_transportation_geom_idx ON brn.road_transportation_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * shipping_m26
 * ------------
 * 
 */
CREATE TABLE brn.shipping_m26
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
    bnrset_id integer,

    CONSTRAINT shipping_fkey_gcn_sectors FOREIGN KEY (gcn_sector_id) REFERENCES gcn_sectors,
    CONSTRAINT shipping_fkey_substances FOREIGN KEY (substance_id) REFERENCES substances
);

CREATE INDEX IF NOT EXISTS shipping_idx ON brn.shipping_m26 USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS shipping_geom_idx ON brn.shipping_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));
