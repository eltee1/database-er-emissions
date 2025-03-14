#
# Product specific settings.
#

$product = :"er-emissions"    # The product these settings are for.

#-------------------------------------

source_path = File.dirname(__FILE__)
sql_path = '/src/main/sql/'
data_path = '/src/data/sql/'
config_path = '/src/build/config/'
settings_file = 'AeriusSettings.rb'

#-------------------------------------

$project_settings_file = File.expand_path(source_path + config_path + settings_file).fix_pathname

$common_sql_paths = 
  [
    File.expand_path(source_path + sql_path + '/common/').fix_pathname,                              # /src/main/sql/common/
  ]

$product_sql_path = File.expand_path(source_path + sql_path).fix_pathname

$common_data_paths =
  [
    File.expand_path(source_path + data_path + '/common/').fix_pathname,                             # /src/main/sql/common/
  ] 
  
$product_data_path = File.expand_path(source_path + data_path + '/er-emissions/').fix_pathname       					
