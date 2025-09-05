SELECT ae_raise_notice('Build: agg_aggregated_brn_shipping_final per groupid @ ' || timeofday());

{multithread on: SELECT groupid FROM shipping.temp_groupids ORDER BY groupid}
	BEGIN; SELECT shipping.build_aggregated_brn_shipping_final({groupid}); COMMIT;
{/multithread}
