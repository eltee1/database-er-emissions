clear_log

begin

  import_database_structure
  
  #update_comments #het build-script kan niet omgaan met IF EXISTS- statements bij het laden van comments, het comment aanmaken gebeurt dus m.b.v. een COMMENT- statement.

  load_data

ensure

end
