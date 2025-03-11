clear_log

create_database :overwrite_existing

check_datasources

begin
  import_database_structure

  update_comments

  load_data

end
