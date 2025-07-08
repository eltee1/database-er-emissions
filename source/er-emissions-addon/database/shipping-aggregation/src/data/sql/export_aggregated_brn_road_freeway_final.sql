SELECT system.store_query('agg_aggregated_brn_shipping_final',
	$$ SELECT
		snr,
		x_m,
		y_m,
		q_g_s,
		gcn_sector_id,
		substance_id,
		groupid,
		grid_size_id,
		r_m,
		grid_n2k_cluster_id

	FROM shipping.agg_aggregated_brn_shipping_final
	$$,
	'{data_folder}/export/{queryname}_{datesuffix}.txt'
);
