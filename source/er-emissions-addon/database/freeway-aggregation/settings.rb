#
# Product specific settings.
#

$product = :"freeway-aggrigation"    # The product these settings are for.

#-------------------------------------

source_path = File.dirname(__FILE__)
sql_path = '/src/main/sql/'
data_path = '/src/data/sql/'
config_path = '../../../build/config/'
settings_file = 'AeriusSettings.rb'

#-------------------------------------

$project_settings_file = File.expand_path(source_path + config_path + settings_file).fix_pathname

$product_sql_path = File.expand_path(source_path + sql_path).fix_pathname           # src/main/sql/

$common_sql_paths = 
  [
    $product_sql_path #temp build script required common path
  ]

$product_data_path = File.expand_path(source_path + data_path).fix_pathname         # src/data/sql/

$common_data_paths =
  [
    $product_data_path #temp build script required common path
  ]
