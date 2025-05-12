/*
 * posint
 * ------
 * Integer value type which can only be positive or 0.
 * Used for the diameter of a source for example.
 */
CREATE DOMAIN posint AS integer
	CHECK (VALUE >= 0::integer);


/*
 * posreal
 * -------
 * Real (decimal) value type which can only be positive or 0.
 * Used for depositions for example.
 */
CREATE DOMAIN posreal AS real
	CHECK (VALUE >= 0::real);


/*
 * fraction
 * --------
 * Real (decimal) value type between 0 and 1 (inclusive), specifying fractions.
 * Used for the habitat coverage factor for example.
 */
CREATE DOMAIN fraction AS real
	CHECK ((VALUE >= 0::real) AND (VALUE <= 1::real));


/*
 * year_type
 * ---------
 * Small integer value type which can only be valid years (2000-2050 currently).
 * Used for background years for example.
 */
CREATE DOMAIN year_type AS smallint
	CHECK ((VALUE >= 2000::smallint) AND (VALUE <= 2050::smallint));


/*
 * year_category_type
 * ------------------
 * Jaarcategorie, voor welke toepassing een jaar wordt gebruikt.
 * source = Het jaar waarvan de bronbestanden zijn berekend.
 * last = Achtergrond depostitie (calculator).
 * past = Een jaar in het verleden die niet 'last' is.
 * future = Prognosejaren.
 * reference = Vergelijkingsjaar voor prognoses.
 * Het referentie jaar kan hierdoor afwijken van het achtergrond-depositie jaar
 */
CREATE TYPE year_category_type AS ENUM
	('source', 'past', 'last', 'future', 'reference');


/*
 * ae_key_value_rs
 * ---------------
 * Type used as a return type in the case where a key-value pair is returned.
 * Intended for use by the aggregate function ae_max_with_key, but can be used for other means as well.
 */
CREATE TYPE ae_key_value_rs AS
(
	key numeric,
	value numeric
);
