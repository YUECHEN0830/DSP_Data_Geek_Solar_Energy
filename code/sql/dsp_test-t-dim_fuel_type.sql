use dsp_test
;
CREATE TABLE dim_fuel_type (
	dim_fuel_type_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,fuel_group varchar(50)
	,fuel_type varchar(50)
	,CONSTRAINT dim_fuel_type_pk PRIMARY KEY (dim_fuel_type_key)
)
;
/*
ALTER TABLE dim_fuel_type
  MODIFY COLUMN `dim_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP
;
ALTER TABLE dim_fuel_type
   MODIFY COLUMN dim_updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
;
TRUNCATE TABLE dim_fuel_type 
*/
;
/*
  dim_solar_panel
*/
CREATE TABLE dim_solar_panel (
	dim_solar_panel_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,`Manufacturer` varchar(100)
	,`URL` varchar(100)
	,`Model` varchar(100)
	,`Detail` varchar(100)
	,`Series` varchar(100)
	,`Current Model` varchar(100)
	,`Country of Manufacturer` varchar(100)
	,`Wattage PMAX` varchar(100)
	,`Power Tolerance` varchar(100)
	,`Short Circuit Current (ISC)` varchar(100)
	,`Open Circuit Voltage (VOC)` varchar(100)
	,`Module Efficiency` varchar(100)
	,`Temperature Coefficient` varchar(100)
	,CONSTRAINT dim_solar_panel_pk PRIMARY KEY (dim_solar_panel_key)
)
;
/*
  dim_aus_state
*/
CREATE TABLE dim_aus_state (
	dim_aus_state_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,`state` varchar(100)
	,CONSTRAINT dim_aus_state_pk PRIMARY KEY (dim_aus_state_key)
)
;
insert into dim_aus_state (`state`) values ('Northern Territory')
;
insert into dim_aus_state (`state`) values ('Queensland')
;
insert into dim_aus_state (`state`) values ('Victoria')
;
insert into dim_aus_state (`state`) values ('New South Wales')
;
insert into dim_aus_state (`state`) values ('ACT')
;
insert into dim_aus_state (`state`) values ('Tasmania')
;
insert into dim_aus_state (`state`) values ('South Australia')
;
insert into dim_aus_state (`state`) values ('Western Australia')
;
/*
  dim_climate_zone
*/
CREATE TABLE dim_climate_zone (
	dim_climate_zone_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,`climate_zone` varchar(100)
	,CONSTRAINT dim_climate_zone_pk PRIMARY KEY (dim_climate_zone_key)
)
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 1')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 2')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 3')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 4')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 5')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 6')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 7')
;
insert into dim_climate_zone (`climate_zone`) values ('Climate Zone 8')
;
insert into dim_climate_zone (`climate_zone`) values ('Adelaide and Environs')
;
insert into dim_climate_zone (`climate_zone`) values ('Mt Lofty ranges')
;
insert into dim_climate_zone (`climate_zone`) values ('Yorke Peninsula and Kangaroo Island')
;
insert into dim_climate_zone (`climate_zone`) values ('Murraylands and Riverland')
;
insert into dim_climate_zone (`climate_zone`) values ('South East')
;
insert into dim_climate_zone (`climate_zone`) values ('Mid North')
;
insert into dim_climate_zone (`climate_zone`) values ('Central North')
;
insert into dim_climate_zone (`climate_zone`) values ('Port Augusta and Pastoral')
;
insert into dim_climate_zone (`climate_zone`) values ('Eastern Eyre')
;
insert into dim_climate_zone (`climate_zone`) values ('West Coast')
;
select * from dim_climate_zone
;
/*
  dim_household_size
*/
CREATE TABLE dim_household_size (
	dim_household_size_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,`household_size` varchar(100)
	,CONSTRAINT dim_household_size_pk PRIMARY KEY (dim_household_size_key)
)
;
insert into dim_household_size (`household_size`) values ('1 Person Household')
;
insert into dim_household_size (`household_size`) values ('2 Person Household')
;
insert into dim_household_size (`household_size`) values ('3 Person Household')
;
insert into dim_household_size (`household_size`) values ('4 Person Household')
;
insert into dim_household_size (`household_size`) values ('5+ Person Household')
;
select * from dim_household_size
;
/*
  fct_household_electricity_consumption_benchmark
*/
CREATE TABLE fct_household_electricity_consumption_benchmark (
	fct_household_electricity_consumption_benchmark_key int(11) NOT NULL AUTO_INCREMENT
	,fct_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_aus_state_key int
	,dim_climate_zone_key int
	,dim_household_size_key int
	,swimming_pool_ind char(1)
	,`autumn_kWh` int
	,`summer_kWh` int
	,`winter_kWh` int
	,`spring_kWh` int
	,CONSTRAINT fct_household_electricity_consumption_benchmark_pk PRIMARY KEY (fct_household_electricity_consumption_benchmark_key)
)
;
