/*
 * ae_percentile_sorted_array
 * --------------------------
 * Function to calculate the percentile based on a sorted array.
 */
CREATE OR REPLACE FUNCTION ae_percentile_sorted_array(sorted_array numeric[], percentile int)
	RETURNS numeric AS
$BODY$
DECLARE
	array_size int;
	index int;
	percentile_by_index real;
BEGIN
	IF array_length(sorted_array, 1) IS NULL THEN -- No empty arrays
		RETURN NULL;
	END IF;

	array_size = array_length(sorted_array, 1);
	index = FLOOR( (array_size - 1) * percentile / 100.0) + 1;

	-- an array of n elements starts with array[1] and ends with array[n].
	IF index >= array_size THEN
		RETURN sorted_array[array_size];

	ELSE
		percentile_by_index = (index - 1) * 100.0 / (array_size - 1);

		RETURN sorted_array[index] + (array_size - 1) *
				((percentile - percentile_by_index) / 100.0) *
				(sorted_array[index + 1] - sorted_array[index]);

	END IF;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE RETURNS NULL ON NULL INPUT;


/*
 * ae_percentile
 * -------------
 * Function to calculate the percentile based on an unsorted list.
 * Remark: there is no aggregate version of this function due to very bad performance.
 */
CREATE OR REPLACE FUNCTION ae_percentile(unsorted_array numeric[], percentile int)
	RETURNS numeric AS
$BODY$
BEGIN
	RETURN ae_percentile_sorted_array((SELECT array_agg(v) FROM (SELECT v FROM unnest(unsorted_array) AS v WHERE v IS NOT NULL ORDER BY 1) AS t), percentile);
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE RETURNS NULL ON NULL INPUT;


/*
 * ae_median
 * ---------
 * Function to calculate the median based on an unsorted list. Identical to 50% percentile.
 * Remark: there is no aggregate version of this function due to very bad performance.
 */
CREATE OR REPLACE FUNCTION ae_median(unsorted_array numeric[])
	RETURNS numeric AS
$BODY$
BEGIN
	RETURN ae_percentile(unsorted_array, 50);
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE RETURNS NULL ON NULL INPUT;


/*
 * ae_max_with_key_sfunc
 * ---------------------
 * State function for 'ae_max_with_key'.
 */
CREATE OR REPLACE FUNCTION ae_max_with_key_sfunc(state numeric[2], e1 numeric, e2 numeric)
	RETURNS numeric[2] AS
$BODY$
BEGIN
	IF state[2] > e2 OR e2 IS NULL THEN
		RETURN state;
	ELSE
		RETURN ARRAY[e1, e2];
	END IF;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * ae_max_with_key_ffunc
 * ---------------------
 * Final function for 'ae_max_with_key'.
 * This function is used to shape the endresult into the correct type.
 */
CREATE OR REPLACE FUNCTION ae_max_with_key_ffunc(state numeric[2])
	RETURNS ae_key_value_rs AS
$BODY$
BEGIN
	RETURN (state[1], state[2]);
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


/*
 * ae_max_with_key
 * ---------------
 * Aggregate function to determine the maximum value in a list of key-values, returning both the key and the value.
 * Input consists of 2 numeric arguments, first should be the key, second should be the value.
 * Output is of the type ae_key_value_rs (which also consists of a numeric key and numeric value).
 */
CREATE AGGREGATE ae_max_with_key(numeric, numeric) (
	SFUNC = ae_max_with_key_sfunc,
	STYPE = numeric[2],
	FINALFUNC = ae_max_with_key_ffunc,
	INITCOND = '{NULL,NULL}'
);


/*
 * ae_weighted_avg_sfunc
 * ---------------------
 * State function for the weighted average function 'ae_weighted_avg'.
 * Collects the total of weighted values and the total of weights in an array with 2 values.
 */
CREATE OR REPLACE FUNCTION ae_weighted_avg_sfunc(state numeric[], value numeric, weight numeric)
	RETURNS numeric[] AS
$BODY$
BEGIN
	RETURN ARRAY[COALESCE(state[1], 0) + (value * weight), COALESCE(state[2], 0) + weight];
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE RETURNS NULL ON NULL INPUT;


/*
 * ae_weighted_avg_ffunc
 * ---------------------
 * Final function for the weighted average function 'ae_weighted_avg'.
 * Divides the total of the weighted values by the total of the weights (which were collected in an array with 2 values).
 */
CREATE OR REPLACE FUNCTION ae_weighted_avg_ffunc(state numeric[])
	RETURNS numeric AS
$BODY$
BEGIN
	IF state[2] = 0 THEN
		RETURN 0;
	ELSE
		RETURN state[1] / state[2];
	END IF;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE RETURNS NULL ON NULL INPUT;


/*
 * ae_weighted_avg
 * ---------------
 * Aggregate function to determine a weighted average.
 * First parameter is the value, second parameter is the weight.
 * NULL values are skipped, and if there are no non-NULL values, NULL will be returned.
 */
CREATE AGGREGATE ae_weighted_avg(numeric, numeric) (
	SFUNC = ae_weighted_avg_sfunc,
	STYPE = numeric[],
	FINALFUNC = ae_weighted_avg_ffunc,
	INITCOND = '{NULL,NULL}'
);


/*
 * ae_distribute_enum_sfunc
 * ------------------------
 * State function for enum distribution function 'ae_distribute_enum'.
 * Tracks an array with an element for each value in the enum, and sums the weight according to the supplied enum values.
 */
CREATE OR REPLACE FUNCTION ae_distribute_enum_sfunc(state numeric[], key anyenum, weight numeric)
	RETURNS numeric[] AS
$BODY$
BEGIN
	IF array_length(state, 1) IS NULL THEN
		state := array_fill(0, ARRAY[array_length(enum_range(key), 1)]);
	END IF;
	state[ae_enum_to_index(key)] := state[ae_enum_to_index(key)] + weight;
	RETURN state;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE RETURNS NULL ON NULL INPUT;


/*
 * ae_distribute_enum
 * ------------------
 * Aggregate function to count the occurrence of values in an enum, weighted if need be.
 * First parameter is an enum value, second parameter is the weight which should be summed for that enum value.
 * As an example, the weight can be 1 to count the number of occurrences of each enum value, or a 'surface' column to sum the surface per enum value.
 * The return value is an array with as many elements as there are values in the enum, in same order as the enum is defined.
 * Each element consists of the summed value for each respective enum value.
 * NULL values are skipped, and if there are no non-NULL values, NULL will be returned.
 */
CREATE AGGREGATE ae_distribute_enum(anyenum, numeric) (
	SFUNC = ae_distribute_enum_sfunc,
	STYPE = numeric[],
	INITCOND = '{}'
);
