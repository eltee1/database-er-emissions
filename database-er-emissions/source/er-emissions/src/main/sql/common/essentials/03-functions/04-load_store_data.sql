/*
 * ae_load_table
 * -------------
 * Function to copy the data of the supplied file to the supplied table.
 * The file should contain tab-separated text without a header, or tab-separated text with a header when the optional parameter is set to true.
 *
 * @param tablename The table to copy to.
 * @param filespec The file to copy from
 * @param use_pretty_csv_format Optional parameter to specify if file contains a header (true) or not (false). Default false.
 */
CREATE OR REPLACE FUNCTION setup.ae_load_table(tablename regclass, filespec text, use_pretty_csv_format boolean = FALSE)
	RETURNS void AS
$BODY$
DECLARE
	current_encoding text;
	filename text;
	extra_options text = '';
	delimiter_to_use text = E'\t';
	sql text;
BEGIN
	-- set encoding
	EXECUTE 'SHOW client_encoding' INTO current_encoding;
	EXECUTE 'SET client_encoding TO UTF8';

	filename := replace(filespec, '{tablename}', tablename::text);
	filename := replace(filename, '{datesuffix}', to_char(current_timestamp, 'YYYYMMDD'));

	IF filename LIKE '%{revision}%' THEN
		filename := replace(filename, '{revision}', system.ae_get_git_revision());
	END IF;

	IF use_pretty_csv_format THEN
		extra_options := 'HEADER';
	END IF;

	sql := 'COPY ' || tablename || ' FROM ''' || filename || E''' DELIMITER ''' || delimiter_to_use || ''' CSV ' || extra_options;

	RAISE NOTICE '% Starting @ %', sql, timeofday();
	EXECUTE sql;
	RAISE NOTICE '% Done @ %', sql, timeofday();

	-- reset encoding
	EXECUTE 'SET client_encoding TO ' || current_encoding;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


/*
 * ae_store_query
 * --------------
 * Function to store the results of the supplied query string to the supplied file.
 * In the filename the parts {tablename} or {queryname} can be used, these will be replaced by the supplied queryname.
 * Additionally, the part {datesuffix} can be used, which will be replaced with the current date in YYYYMMDD format.
 *
 * The export is tab-separated CSV.
 * The optional parameter use_pretty_csv_format can be used to generate a file with (true) or without (false) a header.
 *
 * @param queryname The name of the query.
 * @param sql_in The actual query string to export the results for.
 * @param filespec The file to export to.
 * @param use_pretty_csv_format Optional parameter to specify if file is generated with a header (true) or not (false). Default false.
 */
CREATE OR REPLACE FUNCTION setup.ae_store_query(queryname text, sql_in text, filespec text, use_pretty_csv_format boolean = FALSE)
	RETURNS void AS
$BODY$
DECLARE
	current_encoding text;
	filename text;
	extra_options text = '';
	delimiter_to_use text = E'\t';
	sql text;
BEGIN
	-- set encoding
	EXECUTE 'SHOW client_encoding' INTO current_encoding;
	EXECUTE 'SET client_encoding TO UTF8';

	filename := replace(filespec, '{queryname}', queryname);
	filename := replace(filename, '{tablename}', queryname);
	filename := replace(filename, '{datesuffix}', to_char(current_timestamp, 'YYYYMMDD'));

	IF filename LIKE '%{revision}%' THEN
		filename := replace(filename, '{revision}', system.ae_get_git_revision());
	END IF;

	filename := '''' || filename || '''';

	IF use_pretty_csv_format THEN
		extra_options := 'HEADER';
	END IF;

	sql := 'COPY (' || sql_in || ') TO ' || filename || E' DELIMITER ''' || delimiter_to_use || ''' CSV ' || extra_options;

	RAISE NOTICE '%', sql;

	EXECUTE sql;

	-- reset encoding
	EXECUTE 'SET client_encoding TO ' || current_encoding;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


/*
 * ae_store_table
 * --------------
 * Copies the data of the supplied table to the supplied file.
 * In the filename the parts {tablename} or {queryname} can be used, these will be replaced by the supplied table name.
 * Additionally, the part {datesuffix} can be used, which will be replaced with the current date in YYYYMMDD format.
 *
 * The export is tab-separated CSV.
 * The optional parameter use_pretty_csv_format can be used to generate a file with (true) or without (false) a header. The default is false.
 *
 * @param tablename The name of the table to export.
 * @param filespec The file to export to.
 * @param ordered Optional parameter to indicate if export should be ordered or not. If true, the table is sorted by all columns, starting with the first column. Default false.
 * @param use_pretty_csv_format Optional parameter to specify if file is generated with a header (true) or not (false). Default false.
 */
CREATE OR REPLACE FUNCTION setup.ae_store_table(tablename regclass, filespec text, ordered bool = FALSE, use_pretty_csv_format boolean = FALSE)
	RETURNS void AS
$BODY$
DECLARE
	ordered_columns_string text;
	tableselect text;
BEGIN
	tableselect := 'SELECT * FROM ' || tablename;

	IF ordered THEN
		SELECT
			array_to_string(array_agg(column_name::text), ', ')
			INTO ordered_columns_string
			FROM
				(SELECT column_name
					FROM information_schema.columns
					WHERE (CASE WHEN table_schema = 'public' THEN table_name ELSE table_schema || '.' || table_name END)::text = tablename::text
					ORDER BY ordinal_position
				) ordered_columns;

		tableselect := tableselect || ' ORDER BY ' || ordered_columns_string || '';
	END IF;

	PERFORM setup.ae_store_query(tablename::text, tableselect, filespec, use_pretty_csv_format);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
