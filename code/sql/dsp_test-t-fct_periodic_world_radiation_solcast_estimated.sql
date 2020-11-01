Use dsp_test
;
/*
  fct_periodic_world_radiation_solcast_estimated
  
  drop table if exists fct_periodic_world_radiation_solcast_estimated
*/
CREATE TABLE fct_periodic_world_radiation_solcast_estimated (
	fct_periodic_world_radiation_solcast_estimated_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_date_key int
	,hour_min varchar(10)
	,latitude decimal(12,6)
	,longitude decimal(12,6)
	,ghi int
	,ebh int
	,dni int
	,dhi int
	,cloud_opacity int
	,pv_estimate decimal(10,4)
	,CONSTRAINT fct_periodic_world_radiation_solcast_estimated_pk PRIMARY KEY (fct_periodic_world_radiation_solcast_estimated_key)
)
;
