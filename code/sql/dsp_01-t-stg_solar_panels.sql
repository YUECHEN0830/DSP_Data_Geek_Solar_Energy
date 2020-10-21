Use db_dsp01
;
/******************************
  stg_solar_panels
*/
DROP TABLE if EXISTS `stg_solar_panels`
;
CREATE TABLE `stg_solar_panels` (
	`Manufacturer` varchar(100),
	`URL` varchar(100),
	`Model` varchar(100),
	`Detail` varchar(100),
	`Series` varchar(100),
	`Current Model` varchar(100),
	`Country of Manufacturer` varchar(100),
	`Wattage PMAX` varchar(100),
	`Power Tolerance` varchar(100),
	`Short Circuit Current (ISC)` varchar(100),
	`Open Circuit Voltage (VOC)` varchar(100),
	`Module Efficiency` varchar(100),
	`Temperature Coefficient` varchar(100)
)
;
LOAD DATA LOCAL INFILE 'N:/Data_Work/20200802 94692 Data Science Practices/AT2/DSP_Data_Geek_Solar_Energy/data/Solar Panel Technical Specs.csv' 
INTO TABLE stg_solar_panels 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
;
select * from `stg_solar_panels`
;

/******************************
  stg_electricity_consumption_benchmarks
*/
DROP TABLE if EXISTS `stg_electricity_consumption_benchmarks`
;
CREATE TABLE `stg_electricity_consumption_benchmarks` (
	`State` varchar(100),
	`Climate Zone` varchar(100),
	`Swimming Pool?` varchar(100),
	`Household Size` varchar(100),
	`Autumn kWh` varchar(100),
	`Summer kWh` varchar(100),
	`Winter kWh` varchar(100),
	`Spring kWh` varchar(100)
)
;
LOAD DATA LOCAL INFILE 'N:/Data_Work/20200802 94692 Data Science Practices/AT2/DSP_Data_Geek_Solar_Energy/data/Australian Energy Regulator/Summary of Benchmarks - postcodes updated March 2018.csv' 
INTO TABLE stg_electricity_consumption_benchmarks 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
;
select * from `stg_electricity_consumption_benchmarks`
;
