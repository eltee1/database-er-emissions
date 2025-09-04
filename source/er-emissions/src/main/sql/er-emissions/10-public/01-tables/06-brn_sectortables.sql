/*
 * m26_agriculture
 * ---------------
 * 
 */
CREATE TABLE brn.m26_agriculture (
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

CREATE INDEX IF NOT EXISTS agriculture_idx ON brn.m26_agriculture USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
-- CREATE INDEX IF NOT EXISTS agriculture_geom_idx ON brn.m26_industry USING gist(st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * m26_industry
 * ------------
 * 
 */
CREATE TABLE brn.m26_industry (
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

CREATE INDEX IF NOT EXISTS industry_idx ON brn.m26_industry USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
-- CREATE INDEX IF NOT EXISTS industry_geom_idx ON brn.m26_industry USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * m26_other
 * ---------
 * 
 */
CREATE TABLE brn.m26_other (
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

CREATE INDEX IF NOT EXISTS brn_other_idx ON brn.m26_other USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
-- CREATE INDEX IF NOT EXISTS brn_other_geom_idx ON brn.m26_other USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * m26_road_freeway
 * ----------------
 * 
 */
CREATE TABLE brn.m26_road_freeway (
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

CREATE INDEX IF NOT EXISTS road_freeway_idx ON brn.m26_road_freeway USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
-- CREATE INDEX IF NOT EXISTS road_freeway_geom_idx ON brn.m26_road_freeway USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * m26_road_transportation
 * -----------------------
 * 
 */
CREATE TABLE brn.m26_road_transportation (
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

CREATE INDEX IF NOT EXISTS road_transportation_idx ON brn.m26_road_transportation USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
-- CREATE INDEX IF NOT EXISTS road_transportation_geom_idx ON brn.m26_road_transportation USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));


/*
 * m26_shipping
 * ------------
 * 
 */
CREATE TABLE brn.m26_shipping (
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

CREATE INDEX IF NOT EXISTS shipping_idx ON brn.m26_shipping USING btree (gcn_sector_id ASC NULLS LAST, substance_id ASC NULLS LAST);
-- CREATE INDEX IF NOT EXISTS shipping_geom_idx ON brn.shippinm26_shippingg_m26 USING gist (st_setsrid(st_point((x_m::numeric + 0.1)::double precision, (y_m::numeric + 0.1)::double precision), 28992));
