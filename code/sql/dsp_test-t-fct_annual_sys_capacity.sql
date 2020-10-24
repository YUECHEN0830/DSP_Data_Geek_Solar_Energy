use dsp_test
;
CREATE TABLE fct_annual_installed_capacity (
	fct_annual_installed_capacity_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,fct_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_aus_state_key int(11)
	,year int(4)
	,mw_installed double
	,CONSTRAINT fct_annual_installed_capacity_pk PRIMARY KEY (fct_annual_installed_capacity_key)
)
;
TRUNCATE TABLE fct_annual_installed_capacity 
;
/*
 * 
CREATE TABLE fct_sys_cost (
)
;
TRUNCATE TABLE fct_sys_cost 
;
*/
