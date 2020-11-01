use(dsp_test)

/*
 *how much average electricity consumption daily in QLD by diff cutomer type
 *average residential daily elec consumptuion per customer per lga, order by year
*/

SELECT  `year`
		,customer_type
		,dlga.local_government_area
		,ROUND(SUM(avg_daily_energy_per_customer_kWh)/COUNT(dlga.local_government_area),2) AS avg_daily_energy_consumption
		FROM 	 (SELECT dim_postcode_key
						,`year` 
						,customer_type 
						,customer_count 
						,daily_energy_per_customer_kWh 
						,ROUND(SUM(daily_energy_per_customer_kWh)/12,2) AS avg_daily_energy_per_customer_kWh
						FROM fct_monthly_energy_consumption_postcode AS fmecp
						WHERE customer_type = "Residential"
						GROUP BY `year` ,dim_postcode_key
				 ) AS t1
LEFT JOIN dim_postcode AS dp on dp.dim_postcode_key = t1.dim_postcode_key
LEFT JOIN dim_local_government_area_postcode AS dlgap ON dlgap.postcode = dp.postcode 
LEFT JOIN dim_local_government_area AS dlga ON  dlga.dim_local_government_area_key = dlgap.dim_local_government_area_key 
GROUP BY `year`, dlga.local_government_area 			
ORDER BY `year`
;

/*
 * average solar daily consumptuion per customer per lga, order by year
*/
SELECT  `year`
		,customer_type
		,dlga.local_government_area
		,ROUND(SUM(avg_daily_energy_per_customer_kWh)/COUNT(dlga.local_government_area),2) AS avg_daily_energy_consumption
		FROM 	 (SELECT dim_postcode_key
						,`year` 
						,customer_type 
						,customer_count 
						,daily_energy_per_customer_kWh 
						,ROUND(SUM(daily_energy_per_customer_kWh)/12,2) AS avg_daily_energy_per_customer_kWh
						FROM fct_monthly_energy_consumption_postcode AS fmecp
						WHERE customer_type = "Solar"
						GROUP BY `year` ,dim_postcode_key
				 ) AS t1
LEFT JOIN dim_postcode AS dp on dp.dim_postcode_key = t1.dim_postcode_key
LEFT JOIN dim_local_government_area_postcode AS dlgap ON dlgap.postcode = dp.postcode 
LEFT JOIN dim_local_government_area AS dlga ON  dlga.dim_local_government_area_key = dlgap.dim_local_government_area_key 
GROUP BY `year`, dlga.local_government_area 			
ORDER BY `year`
;

/*
 * rolling installed capacity and number of installations
*/ 

SELECT fmsip.`year` 
	   ,fmsip.`month` 
	   ,SUM(fmsip.installations_count) AS installed_number
	   ,SUM(fmsip.rated_output_kW) AS rated_output
FROM dsp_test.fct_monthly_solar_installation_postcode as fmsip
GROUP BY `year` ,`month`
;

SELECT `year`
       ,`month`
       ,dlga.local_government_area
       ,SUM(installations_count) AS installed_number
       ,SUM(rated_output_kW) AS output_in_kW
FROM dsp_test.fct_monthly_solar_installation_postcode fmsip 
LEFT JOIN dim_postcode AS dp ON dp.dim_postcode_key  = fmsip.dim_postcode_key 
LEFT JOIN dim_local_government_area_postcode AS dlgap ON dlgap.postcode = dp.postcode 
LEFT JOIN dim_local_government_area AS dlga ON dlga.dim_local_government_area_key = dlgap.dim_local_government_area_key 
GROUP BY `year`,`month`,local_government_area 
;