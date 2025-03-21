/*
 * ae_protect_table
 * ----------------
 * Simple trigger function to make a table readonly.
 * Useful for 'abstract base tables'.
 */
CREATE OR REPLACE FUNCTION ae_protect_table()
	RETURNS trigger AS
$BODY$
BEGIN
	RAISE EXCEPTION '%.% is a protected/readonly table!', TG_TABLE_SCHEMA, TG_TABLE_NAME;
END;
$BODY$
LANGUAGE plpgsql;


/*
 * ae_raise_notice
 * ---------------
 * Function for showing report messages, mainly during a database build.
 * This is a wrapper around the plpgsql notice function, so this can be called from normal SQL (outside a function).
 */
CREATE OR REPLACE FUNCTION ae_raise_notice(message text)
	RETURNS void AS
$BODY$
DECLARE
BEGIN
	RAISE NOTICE '%', message;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * ae_linear_interpolate
 * ---------------------
 * Linear interpolation function.
 *
 * xb, yb = Start point
 * xe, ye = End point
 * xi = the x value to interpolate the y value for.
 * Expects a float for each value, and returns a float.
 */
CREATE OR REPLACE FUNCTION ae_linear_interpolate(xb float, xe float, yb float, ye float, xi float)
	RETURNS float AS
$BODY$
DECLARE
BEGIN
	IF xe - xb = 0 THEN
		RETURN yb;
	ELSE
		RETURN yb + ( (xi - xb) / (xe - xb) ) * (ye - yb);
	END IF;

END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * ae_linear_interpolate
 * ---------------------
 * Linear interpolation function.
 *
 * xb, yb = Start point
 * xe, ye = End point
 * xi = the x value to interpolate the y value for.
 * Expects integer values for xb,xe and xi.
 * Expects real values for yb and ye.
 * Returns a real value.
 */
CREATE OR REPLACE FUNCTION ae_linear_interpolate(xb integer, xe integer, yb real, ye real, xi integer)
	RETURNS real AS
$BODY$
DECLARE
BEGIN
	IF xe - xb = 0 THEN
		RETURN yb;
	ELSE
		RETURN yb + ( (xi - xb)::real / (xe - xb) ) * (ye - yb);
	END IF;

END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * ae_array_index
 * --------------
 * Helper function which returns the index (of the first match) of anyelement in anyarray.
 */
CREATE OR REPLACE FUNCTION ae_array_index(anyarray, anyelement)
	RETURNS INT AS
$BODY$
	SELECT i
		FROM (SELECT generate_series(array_lower($1,1), array_upper($1,1))) g(i)

		WHERE $1[i] = $2

		LIMIT 1
$BODY$
LANGUAGE sql IMMUTABLE;


/*
 * ae_abs_threshold
 * ----------------
 * Helper function which returns the x value as an absolute value when it is above the threshold, otherwise returns NULL.
 */
CREATE OR REPLACE FUNCTION ae_abs_threshold(x real, threshold real)
	RETURNS REAL AS
$BODY$
	SELECT CASE WHEN ABS(x) > threshold THEN x ELSE NULL END;
$BODY$
LANGUAGE SQL IMMUTABLE;


/*
 * cluster_all_tables
 * ------------------
 * Function to cluster all tables in the database based on their primary key.
 * Once the constraint (in this case the primary key) has been set, in the future clustering can be done by using: CLUSTER databasename.
 */
CREATE OR REPLACE FUNCTION system.cluster_all_tables()
	RETURNS void AS
$BODY$
DECLARE
	pkey_constraints record;
	sql text;
BEGIN
	FOR pkey_constraints IN
		SELECT
			(nspname || '.' || relname)::regclass::text AS tablename,
			conname::text AS pkey_name

			FROM pg_constraint
				INNER JOIN pg_class ON (pg_class.oid = pg_constraint.conrelid)
				INNER JOIN pg_namespace ON (pg_namespace.oid = pg_class.relnamespace)

			WHERE pg_class.relkind = 'r' AND pg_constraint.contype = 'p' AND pg_class.relisshared IS FALSE AND relname NOT LIKE 'pg_%'

			ORDER BY tablename
	LOOP
		sql := 'CLUSTER ' || pkey_constraints.tablename || ' USING ' || pkey_constraints.pkey_name;
		RAISE NOTICE '%', sql;
		EXECUTE sql;
	END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


/*
 * assert_true
 * -----------
 * Function to assert that the supplied condition is true.
 * This assertion is useful for different types of checks.
 */
CREATE OR REPLACE FUNCTION system.assert_true(v_condition boolean, v_message text = NULL)
	RETURNS void AS
$BODY$
BEGIN
	IF v_condition IS NOT TRUE THEN
		RAISE EXCEPTION 'assert_true: condition=% %', v_condition, COALESCE('[' || v_message || ']', '');
	END IF;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;
