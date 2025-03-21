SELECT ae_raise_notice('Build: agg_aggregated_brn_road_freeway_final per groupid @ ' || timeofday());


{multithread on: SELECT groupid FROM freewway.temp_groupids ORDER BY groupid}
	BEGIN; SELECT freeway.build_aggregated_brn_road_freeway_final({groupid}); COMMIT;
{/multithread}

--SELECT unnest(array_agg(generate_series)) AS groupid FROM generate_series(1,24)
--SELECT groupid FROM freewway.temp_groupids ORDER BY groupid
