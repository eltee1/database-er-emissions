#
# Product specific settings.
#

$product = :"er-addon"    # The product these settings are for.

#-------------------------------------

source_path = File.dirname(__FILE__)
sql_path = '/src/main/sql/'
data_path = '/src/data/sql/'
config_path = '../../../build/config/'
settings_file = 'AeriusSettings.rb'

#-------------------------------------

$project_settings_file = File.expand_path(source_path + config_path + settings_file).fix_pathname

$common_sql_paths = 
  [
    File.expand_path(source_path + '../../../modules/' + sql_path).fix_pathname      # ../../../modules/src/main/sql/
  ]

$product_sql_path = File.expand_path(source_path + sql_path).fix_pathname

$common_data_paths =
  [
    File.expand_path(source_path + '../../../modules/' + data_path).fix_pathname    # ../../../modules/src/data/sql/
  ]
$product_data_path = File.expand_path(source_path + data_path).fix_pathname         # src/data/sql/monitor/
