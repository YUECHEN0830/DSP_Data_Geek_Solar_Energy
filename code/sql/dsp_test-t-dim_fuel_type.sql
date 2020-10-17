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
ALTER TABLE dim_fuel_type
  MODIFY COLUMN `dim_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP
;
ALTER TABLE dim_fuel_type
   MODIFY COLUMN dim_updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
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
