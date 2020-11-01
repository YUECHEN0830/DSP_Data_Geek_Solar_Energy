Use dsp_test
;
/*
  fct_solar_installation
  
  drop table if exists fct_solar_installation
*/
CREATE TABLE fct_solar_installation (
	fct_solar_installation_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_postcode_suburb_key int
	,dim_date_key int
	,`nmi#` int
	,inverter_capacity int
	,CONSTRAINT fct_solar_installation_pk PRIMARY KEY (fct_solar_installation_key)
)
;
