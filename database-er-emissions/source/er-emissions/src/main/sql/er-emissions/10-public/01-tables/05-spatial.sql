/*
 * geo_vierkanten
 * --------------
 * -
 */
CREATE TABLE geo_vierkanten (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	r_m integer NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT geo_vierkanten_pkey PRIMARY KEY (ai_code)
);


/*
 * geo_verfijnd
 * ------------
 * 
 */
CREATE TABLE geo_verfijnd (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT geo_verfijnd_pkey PRIMARY KEY (ai_code)

);

CREATE UNIQUE INDEX idx_geo_verfijnd ON geo_verfijnd (tle_id,ai_code);
CREATE INDEX idx_geo_verfijnd_gist ON geo_verfijnd USING GIST (geometry);


/*
 * geo_eri
 * -------
 * 
 */
CREATE TABLE geo_eri (
	tle_id integer NOT NULL, 
	ai_code text NOT NULL,
	emissiebrontype text NOT NULL,
	nic_naam text NOT NULL,
	emissiepunt_naam text NOT NULL,
	nic text NOT NULL,
	volgnummer integer NOT NULL,
	xmidden integer NOT NULL,
	ymidden integer NOT NULL,
	hoogte integer NOT NULL,
	lengte integer NOT NULL,
	breedte integer NOT NULL,
	hoek double precision NOT NULL,
	beginjaar integer NOT NULL,
	eindjaar integer NOT NULL,
	uitstroomopening_m2 integer NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT geo_eri_pkey PRIMARY KEY (ai_code)
);


/*
 * geo_vliegvelden
 * ---------------
 * 
 */
CREATE TABLE geo_vliegvelden (
	tle_id integer NOT NULL, 
	ai_code text NOT NULL, 
	naam text NOT NULL, 
	nic  text NOT NULL, 
	volgnummer integer NOT NULL,
	soort text NOT NULL, 
	lengte integer NOT NULL,
	breedte integer NOT NULL,
	hoogte integer NOT NULL,
	xmidden integer NOT NULL,
	ymidden integer NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT geo_vliegvelden_pkey PRIMARY KEY (ai_code)
);


/*
 * verfijning_type
 * ---------------
 * 
 */
CREATE TABLE verfijning_type (
	tle_id integer NOT NULL,
	geo_layer text NOT NULL, 
	geo_fclass_er text NOT NULL,
	geo_set_type text NOT NULL,
	levering text NOT NULL--,

	--CONSTRAINT verfijning_type_pkey PRIMARY KEY () --UNIEKE IDENTITY kolom aanmaken voor PKEY?
);


/*
 * wegen
 * -----
 * 
 */
CREATE TABLE wegen (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	nummer integer NOT NULL,
	vak text NOT NULL,
	naam text NOT NULL,
	soort text NOT NULL,
	shape_length double precision NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT wegen_pkey PRIMARY KEY (ai_code)
);


/*
 * giab
 * ----
 * 
 */
CREATE TABLE giab (
	tle_id  integer NOT NULL,
	ai_code text NOT NULL,
	xco integer NOT NULL,
	yco integer NOT NULL,
	relnr integer NOT NULL,
	giabnr integer NOT NULL,
	nge integer NOT NULL,
	ubn bigint NOT NULL,
	relnr_pch_lbt_pch_nw_ubn_rav text NOT NULL,
	so double precision NOT NULL,
	giabstatus text NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT giab_pkey PRIMARY KEY (ai_code)
);



/*
 * initiator
 * ---------
 * 
 */
CREATE TABLE initiator (
	tle_id  integer NOT NULL,
	ai_code text NOT NULL,
	zone_12_mijl text NOT NULL,
	r_m integer NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT initiator_key PRIMARY KEY (ai_code)
)
;


/*
 * mestverwerkers
 * --------------
 * 
 */
CREATE TABLE mestverwerkers (
	tle_id  integer NOT NULL,
	ai_code text NOT NULL,
	nummer integer NOT NULL,
	vnr integer NOT NULL,
	naam text NOT NULL,
	type text NOT NULL,
	adres text NOT NULL,
	huisnr text NOT NULL,
	huisnr_toev text NOT NULL,
	postcode text NOT NULL,
	plaats text NOT NULL,
	aantal_werknemers double precision NOT NULL,
	opname_instantie text NOT NULL,
	code_instantie text NOT NULL,
	sbi_code text NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT mestverwerkers_key PRIMARY KEY (ai_code)
);



/*
 * spoorwegen
 * ----------
 * 
 */
CREATE TABLE spoorwegen (
	tle_id  integer NOT NULL,
	ai_code text NOT NULL,
	shape_length double precision NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT spoorwegen_key PRIMARY KEY (ai_code)
);



/*
 * binnenvaart
 * -----------
 * 
 */
CREATE TABLE binnenvaart (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	vaarweg_id integer NOT NULL,
	vaarwegnaam text NOT NULL,
	shape_length double precision NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT binnenvaart_key PRIMARY KEY (ai_code)
);


/*
 * recreatievaart
 * --------------
 * 
 */
CREATE TABLE recreatievaart (
	tle_id integer NOT NULL,
	ai_code text NOT NULL,
	vwk_id integer NOT NULL,
	vrt_id integer NOT NULL,
	vwg_nr integer NOT NULL,
	richting text NOT NULL,
	vaktype text NOT NULL,
	vaklengte double precision NOT NULL,
	shape_length double precision NOT NULL,
	vwv_naam text NOT NULL,
	geometry geometry NOT NULL,

	CONSTRAINT recreatievaart_key PRIMARY KEY (ai_code)
);

