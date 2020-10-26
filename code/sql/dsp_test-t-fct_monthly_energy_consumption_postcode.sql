/*
  fct_monthly_energy_consumption_postcode
  
  drop table if exists fct_monthly_energy_consumption_postcode
*/
CREATE TABLE fct_monthly_energy_consumption_postcode (
	fct_monthly_energy_consumption_postcode_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_postcode_key int
	,`year` int
	,`month` int
	,customer_type varchar(20)
	,customer_count int
	,daily_energy_per_customer_kWh decimal(12,6)
	,CONSTRAINT fct_monthly_energy_consumption_postcode_pk PRIMARY KEY (fct_monthly_energy_consumption_postcode_key)
)
;
