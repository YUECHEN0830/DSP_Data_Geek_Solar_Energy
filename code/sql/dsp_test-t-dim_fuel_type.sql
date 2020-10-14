use dsp_test
;
CREATE TABLE dim_fuel_type (
	dim_fuel_type_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime
	,dim_updated_date datetime
	,fuel_group varchar(50)
	,fuel_type varchar(50)
	,CONSTRAINT dim_fuel_type_pk PRIMARY KEY (dim_fuel_type_key)
)
;
TRUNCATE TABLE dim_fuel_type 
;
/*
 * 
CREATE TABLE fct_fuel_type (
)
;
TRUNCATE TABLE fct_fuel_type 

*/
