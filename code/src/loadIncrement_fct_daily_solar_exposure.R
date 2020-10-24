library("RMySQL")
library(rstudioapi)
library(tidyverse)

################################################
dwh_user <- Sys.getenv("dwh_username")
dwh_passwd <- Sys.getenv("dwh_password")
dwh_dbname <- 'dsp_test'
dwh_host <- 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com'

sql_raw_data <- 'select
	LPAD(`Station number`,6,"0000") as station_number
	,CAST(CONCAT(Year,LPAD(Month,2,"00"),LPAD("01",2,"00")) as SIGNED) as dim_date_key
	,CAST(`Monthly mean daily global solar exposure (MJ/m*m)` AS DECIMAL(8,4)) as daily_exposure
from dsp_test.stg_df_IDC
;
'
################################################
# connect to DWH DB
# get data
db_connection <- db_connect(username = dwh_user, password = dwh_passwd, dbname = dwh_dbname, host = dwh_host)

df_staging <- db_query(db_connection, query_sql = sql_raw_data)

################################################
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
df_load <- df_load %>% rename('daily_exposure' = 'daily_exposure.x')

# Save Records into DIM table
dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_dwh,"fct_daily_solar_exposure",df_load, append=TRUE, row.names=FALSE)
#dbExecute(conn_dwh,"insert into myRealTable(a,b,c) select a,b,c from myTempTable")
#dbExecute(conn_dwh,"drop table if exists myTempTable")
dbExecute(conn_dwh,"commit;")
