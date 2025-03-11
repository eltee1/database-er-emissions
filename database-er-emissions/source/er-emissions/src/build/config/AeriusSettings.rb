#
# Application specific settings. Define override values in AeriusSettings.User.rb (same location).
#

$runscripts_path = File.expand_path(File.dirname(__FILE__) + '/../scripts/').fix_pathname

$pg_username = 'aerius'
$pg_password = '...' # Override in AeriusSettings.User.rb

$dbdata_dir = 'dbdata/er-aggregatie/'
# Default data path is next to the root of the checked out project.
$dbdata_path = File.expand_path(File.dirname(__FILE__) + '/../../../../../../../' + $dbdata_dir).fix_pathname

$database_name_prefix = 'AERIUS'
$db_function_prefix = 'ae'

$source = :https
$target = :local

$https_data_path = 'https://nexus.aerius.nl/repository'
$https_data_username = '' # Override in AeriusSettings.User.rb
$https_data_password = '' # Override in AeriusSettings.User.rb

$git_bin_path = '' # Git bin folder should be in PATH
