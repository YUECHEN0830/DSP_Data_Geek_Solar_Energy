Use dsp_test
;
/*
  fct_monthly_solar_installation_postcode
  
  drop table if exists fct_monthly_solar_installation_postcode
*/
CREATE TABLE fct_monthly_solar_installation_postcode (
	fct_monthly_solar_installation_postcode_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_postcode_key int
	,`year` int
	,`month` int
	,installations_count int
	,rated_output_kW int
	,CONSTRAINT fct_monthly_solar_installation_postcode_pk PRIMARY KEY (fct_monthly_solar_installation_postcode_key)
)
;
