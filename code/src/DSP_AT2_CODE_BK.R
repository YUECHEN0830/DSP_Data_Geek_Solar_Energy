library(readr)
library(here)
library(reshape2)
library(knitr)
source(here::here("code/common", "mysql_connection.R"))
library(dplyr)
library (tidyverse) 
library (dplyr)
library (lubridate)
library (expss)
library (ggplot2)
library (stringr)
library(ggthemes)
library(here)
library(leaflet)
library(htmlwidgets)
library(corrplot)
library(hydroGOF)




# using configuration file
config <- read.csv(here::here("code/config", "db_connection_config.csv"))
# myconfig <- config %>% filter(user_key == "cecilia_rds")
myconfig <- config %>% filter(user_key == "rato_rds")



db_connection <- db_connect(myconfig)



sql_latitude_whether_station <- 'SELECT
    dws.latitude
    ,dws.longitude
    ,f.dim_date_key
    ,f.daily_exposure
  ,dws.station_name
    
FROM fct_daily_solar_exposure as f
left join dim_weather_station as dws on dws.dim_weather_station_key = f.dim_weather_station_key
   

 

;
'
#sql average solar exposure



sql_average_solar_exposure <- 'SELECT
dws.latitude,
dws.longitude,
AVG(f.daily_exposure) AS avg_daily_exposure,
dws.station_name
FROM
fct_daily_solar_exposure AS f
LEFT JOIN
dim_weather_station AS dws ON dws.dim_weather_station_key = f.dim_weather_station_key
GROUP BY dws.latitude , dws.longitude , dws.station_name
;
'






sql_solar_exposure <- "select
    STR_TO_DATE(CAST(f.dim_date_key as CHAR), '%Y%m%d') as solar_date
    ,dws.station_number 
    ,dws.station_name 
    ,f.daily_exposure 
from fct_daily_solar_exposure as f
left join dim_weather_station as dws on dws.dim_weather_station_key = f.dim_weather_station_key 
where 1=1
and dws.dim_weather_station_key is not null
and f.dim_date_key BETWEEN 20200101 and 20201231
and dws.station_number = '066062'
;
"




#daily temp



sql_average_temp <- "SELECT
dws.dim_weather_station_key,
--     t.dim_date_key,
dws.station_name,
dd.CalendarYear,
dd.CalendarMonth,
dd.CalendarMonthName,
case 
when dd.CalendarMonth in (9,10,11) then 'spring'
when dd.CalendarMonth in (12,1,2) then 'summer'
when dd.CalendarMonth in (3,4,5) then 'autumn'
when dd.CalendarMonth in (6,7,8) then 'winter'
end as season
,avg(t.min_temperature) as avg_min_temperature
,avg(t.max_temperature) as avg_max_temperature
,avg(fdse.daily_exposure) as avg_exposure
-- select count(*)
FROM fct_daily_temperature AS t
LEFT JOIN fct_daily_solar_exposure AS fdse ON fdse.dim_weather_station_key = t.dim_weather_station_key
AND fdse.dim_date_key = t.dim_date_key
LEFT JOIN dim_weather_station AS dws ON dws.dim_weather_station_key = t.dim_weather_station_key
LEFT JOIN dim_date AS dd ON dd.dim_date_key = t.dim_date_key
-- WHERE t.dim_weather_station_key = 2
group by
dws.dim_weather_station_key,
--     t.dim_date_key,
dws.station_name
,dd.CalendarYear
,dd.CalendarMonth
,dd.CalendarMonthName
;
"









# get data



df_daily_solar_exposure <- db_query(db_connection, query_sql = sql_latitude_whether_station)
df_average_solar_exposure <- db_query(db_connection, query_sql = sql_average_solar_exposure)
df_average_temp <- db_query(db_connection, query_sql = sql_average_temp)




db_disconnect(db_connection)



df_average_solar_exposure$avg_daily_exposure=round(df_average_solar_exposure$avg_daily_exposure,2)
df_average_temp$avg_temp=round(df_average_temp$avg_temp,2)
#quantile(df_average_solar_exposure)
solar_exposure_map=leaflet(df_average_solar_exposure) %>% 
  addTiles() %>% 
  addCircleMarkers(
    lng=~longitude, 
    lat=~latitude,
    label = ~avg_daily_exposure,
    labelOptions = labelOptions(noHide = T),
    radius = ~case_when(
      avg_daily_exposure<=14.95718~4,
      avg_daily_exposure<=17.01499~6,
      avg_daily_exposure<=19.60843~8,
      avg_daily_exposure<=21.23699~10,
      
      TRUE~12
    ),
    stroke = FALSE, fillOpacity = 0.5  )



# Save Map
saveWidget(widget = solar_exposure_map,
           file = "df_daily_solar_exposure.html",
           selfcontained = TRUE)



ggplot(df_average_solar_exposure, aes(x=latitude, y=avg_daily_exposure)) +
  geom_point(size=2, shape=23)+
  geom_smooth(method=lm)



ggplot(df_average_temp, aes(x=latitude, y=avg_daily_exposure)) +
  geom_point(size=2, shape=23)+
  geom_smooth(method=lm)






#plot 



plot(df_daily_solar_exposure$dim_date_key,df_daily_solar_exposure$daily_exposure)




#monthly data
df_daily_solar_exposure_modify=df_daily_solar_exposure %>% 
  mutate(month_year=substring(dim_date_key,1,6)) %>% 
  group_by(month_year) %>% 
  summarise(min=min(daily_exposure,na.rm=TRUE),
            max=max(daily_exposure,na.rm=TRUE),
            mean=mean(daily_exposure,na.rm=TRUE))

plot(df_daily_solar_exposure_modify$month_year,df_daily_solar_exposure_modify$mean)



df_daily_temp_modify <- df_average_temp %>% 
  # mutate(month_year=substring(dim_date_key,1,6)) %>% 
  # group_by(month_year) %>% 
  dplyr::group_by(season, station_name) %>%
  # dplyr::summarise(n())
  dplyr::summarise(
            min_temp = min(avg_min_temperature,na.rm=TRUE),
            max_temp = max(avg_max_temperature,na.rm=TRUE),
            mean_temp = mean((avg_min_temperature + avg_max_temperature)/2,na.rm=TRUE),
            mean_avg_exposure = mean(avg_exposure,na.rm=TRUE)
            )
df_daily_temp_modify %>% filter(mean_temp > 50)

ggplot(df_daily_temp_modify %>% na.omit(), aes(x = mean_temp, y = mean_avg_exposure, group = season)) +
  geom_smooth(aes(color = season), se = FALSE) +
  theme_bw(base_family = "Times") +
  labs(x = 'Mean Temperature [°C]', y = 'Mean Solar Exposure [MJ m-2]') +
  scale_colour_hue(name="Season")

# plot(x = df_daily_temp_modify$season, y = df_daily_temp_modify$mean)