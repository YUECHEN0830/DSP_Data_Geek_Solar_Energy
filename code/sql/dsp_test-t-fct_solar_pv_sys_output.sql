use dsp_test
;
CREATE TABLE fct_solar_pv_sys_output (
	fct_solar_pv_sys_output_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,state text
	,city text
	,size double
	,avg_daily_output double
	,CONSTRAINT fct_solar_pv_sys_output_pk PRIMARY KEY (fct_solar_pv_sys_output_key)
)
;
TRUNCATE TABLE dim_sys_cost 
;
/*
 * 
CREATE TABLE fct_sys_cost (
)
;
TRUNCATE TABLE fct_sys_cost 
;
*/
