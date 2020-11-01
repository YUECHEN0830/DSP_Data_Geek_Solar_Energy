Use dsp_test
;
/*
  dim_local_government_area
*/
-- DROP TABLE IF EXISTS dim_local_government_area
CREATE TABLE dim_local_government_area (
	dim_local_government_area_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,local_government_area varchar(100)
	,CONSTRAINT dim_local_government_area_pk PRIMARY KEY (dim_local_government_area_key)
)
;
select * from dim_local_government_area
;
/*
  fct_yearly_lga_solar
*/
CREATE TABLE fct_yearly_lga_solar (
	fct_yearly_lga_solar_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_local_government_area_key int
	,`year` int
	,`daily_average` decimal(8,4)
	,`general_supply` int
	,`off_peak_hot_water` int
	,`total_MWh` int
	,`off_peak_customers` int
	,`ttotal_customers` int
	,`res_sol_customers` int
	,`non_res_sol_customers` int
	,`res_sol_capacity_kWp` int
	,`non_res_sol_capacity_kWp` int
	,`sol_energy_exported_to_ grid_MWh` int
	,`non_res_small-medium_sites_MWh` int
	,`non_res_small-medium_sites_customers` int
	,`non_res_large_sites_MWh` int
	,`non_res_large_sites_customers` int
	,`unmetered_total_MWh` int
	,CONSTRAINT fct_yearly_lga_solar_pk PRIMARY KEY (fct_yearly_lga_solar_key)
)
;
