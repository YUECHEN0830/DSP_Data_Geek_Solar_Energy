---
  title: "DSP AT2 - Datastore 8"
output:
  html_document:
  df_print: paged
---
  
  Dashboard for datastore 8
* Scenario
* - state: QLD
* - Logal government area:5
* - year:10
* - Energy consumption type:2
* 
  * Output
* - avg daily energy consumption

```{r}
library(readr)
library(here::here)
library(reshape2)
library(knitr)
source(here::here("code/common", "mysql_connection.R"))
library(dplyr)
library(tidyr)

# using configuration file
config <- read.csv(here::here("code/config", "db_connection_config.csv"))
myconfig <- config %>% filter(user_key == "rato_rds")

db_connection <- db_connect(myconfig)

sql_elec_consumption_daily <- 'SELECT  `year`
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
'

sql_solar_exposure_consumption_daily <- 'SELECT  `year`
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
'
sql_monthly_solar_installation <- 'SELECT `year`
       ,`month`
       ,dlga.local_government_area
       ,SUM(installations_count) AS installed_number
       ,SUM(rated_output_kW) AS output_in_kW
FROM dsp_test.fct_monthly_solar_installation_postcode fmsip 
LEFT JOIN dim_postcode AS dp ON dp.dim_postcode_key  = fmsip.dim_postcode_key 
LEFT JOIN dim_local_government_area_postcode AS dlgap ON dlgap.postcode = dp.postcode 
LEFT JOIN dim_local_government_area AS dlga ON dlga.dim_local_government_area_key = dlgap.dim_local_government_area_key 
GROUP BY `year`,`month`
;
'


# get data
df_daily_elec_consumption <- db_query(db_connection, query_sql = sql_elec_consumption_daily)

df_daily_solar_consumption<- db_query(db_connection, query_sql = sql_solar_exposure_consumption_daily)

df_monthly_solar_installation <- db_query(db_connection, query_sql = sql_monthly_solar_installation)

db_disconnect(db_connection)
```
df_monthly_solar_installation <- tidyr::unite(df_monthly_solar_installation, "YearMonth", year, month)


#Get rolling installed capacity and number of installations by diff local governmnt area
Brisbane_data <- filter(df_monthly_solar_installation, local_government_area == "BRISBANE")
NorthCoast_data <- filter(df_monthly_solar_installation, local_government_area == "NORTH COAST")
SouthEast_data <- filter(df_monthly_solar_installation, local_government_area == "SOUTH EAST")
SouthWest_data <- filter(df_monthly_solar_installation, local_government_area == "SOUTH WEST")
CentralQLD_data <- filter(df_monthly_solar_installation, local_government_area == "CENTRAL QUEENSLAND")



#Here we can do some plotting to showcase what we find in the data.
```{r ann-install}
library(ggplot2)

g_electricity<-ggplot(df_daily_elec_consumption, aes(x=year,y=avg_daily_energy_consumption,color=local_government_area)) +
  geom_line() + 
  geom_point() +
  labs(x = "Year", y = "Energy per customer per day (kWh)",title = "Daily Electricity Consumption Trend") + 
  theme(plot.title = element_text(hjust = 0.5)) +scale_color_discrete(name="Local Government Area")

g_solar<-ggplot(df_daily_solar_consumption, aes(x=year,y=avg_daily_energy_consumption,colour=local_government_area)) +
  geom_line() + 
  geom_point() +
  labs(x = "Year", y = "Energy per customer per day (kWh)",title = "Daily Solar Energy Consumption Trend") + 
  theme(plot.title = element_text(hjust = 0.5)) +scale_color_discrete(name="Local Government Area")

g_solar_installation <- ggplot(df_monthly_solar_installation, aes(x=YearMonth,y=installed_number)) +
  geom_line(aes(group=1), colour="#E69F00") + 
  geom_point(size=2, colour="#D55E00") +
  labs(x = "Year", y = "No. of installations",title = "Number of installations") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5)) 
 
g_output<- ggplot(df_monthly_solar_installation, aes(x=YearMonth,y=output_in_kW/1000)) +
  geom_line(aes(group=1), colour="#5CACEE") + 
  geom_point(size=2, colour="#36648B") +
  labs(x = "Year", y = "Capacity [MW]",title = "installed capacity") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5)) 

library(Rmisc)
multiplot(g_solar_installation, g_output)



