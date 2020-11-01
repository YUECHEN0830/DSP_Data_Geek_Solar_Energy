Use dsp_test
;
/*
 * Estimated Electricity Consumption per day
 */
SELECT
	das.state
	,das.short_code 
	,dcz.climate_zone 
	,dhs.household_size 
	,f.fct_created_date
	,f.swimming_pool_ind
	,f.spring_kWh 
	,f.summer_kWh 
	,f.autumn_kWh 
	,f.winter_kWh 
FROM fct_household_electricity_consumption_benchmark as f
left join dim_aus_state as das on das.dim_aus_state_key = f.dim_aus_state_key
left join dim_climate_zone as dcz on dcz.dim_climate_zone_key = f.dim_climate_zone_key
left join dim_household_size as dhs on dhs.dim_household_size_key = f.dim_household_size_key 
;