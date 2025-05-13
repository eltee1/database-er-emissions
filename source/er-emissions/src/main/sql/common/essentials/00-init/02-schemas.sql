/*
 * system
 * ------
 * The system schema contains tables, functions and views for general use.
 */
CREATE SCHEMA system;


/*
 * report
 * ------
 * The report schema contains tables and views used for rapporting purposes.
 */
CREATE SCHEMA report;


/*
 * checks
 * ------
 * The checks schema contains views used for checking purposes. 
 * The name "check" cannot be used because this is a reserved command in SQL. It can be used, but only if all references in the code are wrapped in "" and that is not workable.
 */
CREATE SCHEMA checks;


/*
 * brn
 * ---
 * The brn schema contains tables and views related to brn (bronbestsanden).
 */
CREATE SCHEMA brn;
