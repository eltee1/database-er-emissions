/*
 * validation_result_type
 * ----------------------
 * Enum type for the different validation results.
 * The order of this enum is important, and runs from low to high.
 */
CREATE TYPE setup.validation_result_type AS ENUM
	('success', 'hint', 'warning', 'error');


/*
 * validation_result
 * -----------------
 * Type used as a return type for validation results.
 */
CREATE TYPE setup.validation_result AS (
	result setup.validation_result_type,
	object text,
	message text
);
