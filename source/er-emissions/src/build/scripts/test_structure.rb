clear_log

default_database_name "er-emissions_test_structure"

create_database :overwrite_existing

begin
  import_database_structure
  
  update_comments
  
ensure
  drop_database_if_exists :aggressive if $on_build_server
end
