if has_build_flag :build_shipping_only then
    $logger.writeln "Load data, generate derived tables for ER-shipping aggregation and export generated data to export-folder..."

    #build 
    run_sql "build_aggregated_brn_shipping_final.sql"
	
	#store
	run_sql "export_aggregated_brn_shipping_final.sql"

else
    $logger.writeln "Only generate derived tables for ER-shipping aggregation and export generated data to export-folder..."
    #load shipping aggregation files and prepare for build
    run_sql "load_and_prepare.sql"

    #build 
    run_sql "build_aggregated_brn_shipping_final.sql"
	
	#store
	run_sql "export_aggregated_brn_shipping_final.sql"

end
