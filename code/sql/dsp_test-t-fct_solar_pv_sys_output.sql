use dsp_test
;
CREATE TABLE fct_solar_pv_sys_output (
	fct_solar_pv_sys_output_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,fct_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_aus_state_key int(11)
	,city text
	,dim_solar_sys_cost_key int(11) -- size & price range
	,avg_daily_output double
	,CONSTRAINT fct_solar_pv_sys_output_pk PRIMARY KEY (fct_solar_pv_sys_output_key)
)
;
TRUNCATE TABLE fct_solar_pv_sys_output 
;
/*
 * 
CREATE TABLE fct_sys_cost (
)
;
TRUNCATE TABLE fct_sys_cost 
;
*/
