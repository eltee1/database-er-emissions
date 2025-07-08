if has_build_flag :build_freeway_only then
    $logger.writeln "Load data, generate derived tables for ER-freeway aggregation and export generated data to export-folder..."

    #build 
    run_sql "build_aggregated_brn_road_freeway_final.sql"
	
	#store
	run_sql "export_aggregated_brn_road_freeway_final.sql"

else
    $logger.writeln "Only generate derived tables for ER-freeway aggregation and export generated data to export-folder..."
    #load freeway aggregation files and prepare for build
    run_sql "load_and_prepare.sql"

    #build 
    run_sql "build_aggregated_brn_road_freeway_final.sql"
	
	#store
	run_sql "export_aggregated_brn_road_freeway_final.sql"

end
