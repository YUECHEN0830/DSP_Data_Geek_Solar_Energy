Use dsp_test
;
/*
  dim_weather_station
*/
CREATE TABLE dim_weather_station (
	dim_weather_station_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,`station_number` varchar(10)
	,CONSTRAINT dim_weather_station_pk PRIMARY KEY (dim_weather_station_key)
)
;
select * from dim_weather_station
;
/*
  fct_household_electricity_consumption_benchmark
*/
CREATE TABLE fct_daily_solar_exposure (
	fct_daily_solar_exposure_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_weather_station_key int
	,dim_date_key int
	,`daily_exposure` decimal(8,2)
	,CONSTRAINT fct_daily_solar_exposure_pk PRIMARY KEY (fct_daily_solar_exposure_key)
)
;
