use dsp_test
;
CREATE TABLE fct_sys_installation (
	fct_sys_installation_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,fct_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_aus_state_key int(11)
	,year int(4)
	,number_of_installation int
	,CONSTRAINT fct_sys_installation_pk PRIMARY KEY (fct_sys_installation_key)
)
;
TRUNCATE TABLE fct_sys_installation 
;
/*
 * 
CREATE TABLE fct_sys_cost (
)
;
TRUNCATE TABLE fct_sys_cost 
;
*/
