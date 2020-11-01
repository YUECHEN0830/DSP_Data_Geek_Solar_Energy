use dsp_test
;
CREATE TABLE fct_annual_accredited_installers (
	fct_annual_accredited_installers_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,fct_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_aus_state_key int(11)
	,year int(4)
	,num_accredited_installers int
	,CONSTRAINT fct_annual_accredited_installers_pk PRIMARY KEY (fct_annual_accredited_installers_key)
)
;
TRUNCATE TABLE fct_annual_accredited_installers 
;
/*
 * 
CREATE TABLE fct_sys_cost (
)
;
TRUNCATE TABLE fct_sys_cost 
;
*/
