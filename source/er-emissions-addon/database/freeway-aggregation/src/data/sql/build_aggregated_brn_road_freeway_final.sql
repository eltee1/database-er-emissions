SELECT ae_raise_notice('Build: agg_aggregated_brn_road_freeway_final per groupid @ ' || timeofday());

{multithread on: SELECT groupid FROM freeway.temp_groupids ORDER BY groupid}
	BEGIN; SELECT freeway.build_aggregated_brn_road_freeway_final({groupid}); COMMIT;
{/multithread}
