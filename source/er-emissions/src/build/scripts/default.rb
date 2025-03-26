clear_log

default_database_name "m25_er-emissions"

create_database :overwrite_existing

check_datasources

begin
  import_database_structure

  update_comments

  load_data

  generate_html_documentation

end

dump_database :overwrite_existing unless has_build_flag :quick
