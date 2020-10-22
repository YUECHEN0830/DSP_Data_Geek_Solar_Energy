library("RMySQL")
library(rstudioapi)
library(tidyverse)

################################################
# connect to Staging DB
# Create a connection Object to MySQL database.
conn_staging <- dbConnect(RMySQL::MySQL(), 
                          user = Sys.getenv("stg_username"), 
                          password = Sys.getenv("stg_password"), 
                          port = 3306,
                          dbname = 'db_dsp01',
                          host = 'dsp-01.cnk9sarev6lg.us-east-2.rds.amazonaws.com')

## Get staging records
stg_rows <- dbSendQuery(conn_staging, "SELECT
	`Bureau of Meteorology station number` as station_number
	,CAST(CONCAT(Year,LPAD(Month,2,'00'),LPAD(Day,2,'00')) as SIGNED) as dim_date_key
	,CAST(`Daily global solar exposure (MJ/m*m)` AS DECIMAL(8,4)) as daily_exposure
from db_dsp01.stg_IDCJAC0016_072150_1800_Data
;")
## transform into dataframe
df_staging <- fetch(stg_rows)

## disconnect mysql server
dbDisconnect(conn_staging)

################################################
# Ready to load into DIM table
# Create a connection Object to MySQL database.
conn_dwh <- dbConnect(RMySQL::MySQL(), 
                      user = Sys.getenv("dwh_username"), 
                      password = Sys.getenv("dwh_password"), 
                      port = 3306,
                      dbname = 'dsp_test',
                      host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

dim_weather_station <- dbReadTable(conn_dwh,"dim_weather_station")
fct_daily_solar_exposure <- dbReadTable(conn_dwh,"fct_daily_solar_exposure")

df_stg <- df_staging %>%
  # select(-value, -fin_year) %>%
  # distinct() %>%
  arrange(station_number, dim_date_key)
df_load <- df_stg %>%
  left_join(dim_weather_station, by='station_number') %>%
  left_join(fct_daily_solar_exposure, by=c('dim_weather_station_key','dim_date_key'))
df_load <- df_load %>%
  filter(is.na(fct_daily_solar_exposure_key)==TRUE) %>%
  select(c('dim_weather_station_key', 'dim_date_key', 'daily_exposure.x'))
df_load <- df_load %>% rename("daily_exposure.x" = "daily_exposure")

# Save Records into DIM table
dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_dwh,"fct_daily_solar_exposure",df_load, append=TRUE, row.names=FALSE)
#dbExecute(conn_dwh,"insert into myRealTable(a,b,c) select a,b,c from myTempTable")
#dbExecute(conn_dwh,"drop table if exists myTempTable")
dbExecute(conn_dwh,"commit;")
