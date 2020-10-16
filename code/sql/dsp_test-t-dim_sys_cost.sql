use dsp_test
;
CREATE TABLE dim_sys_cost (
	dim_sys_cost_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime
	,dim_updated_date datetime
	,system_size double
	,number_of_panels int(5)
	,min_cost decimal(10,2)
	,max_cost decimal(10,2)
	,CONSTRAINT dim_sys_cost_pk PRIMARY KEY (dim_sys_cost_key)
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
