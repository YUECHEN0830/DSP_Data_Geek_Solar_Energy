library("RMySQL")
library(rstudioapi)
library(tidyverse)

################################################
# connect to Staging DB
## Get staging records
stg_rows <- read.csv(here("data/raw_datasets/BOM_Temperature", "IDCJAC0010_3003_2020_Data.csv"))
stg_rows$Bureau.of.Meteorology.station.number <- 

################################################
# Ready to load into DIM table
# Create a connection Object to MySQL database.
# Create a connection Object to MySQL database.
config <- read.csv(here("code/config", "db_connection_config.csv"))
myconfig <- config %>% filter(user_key == "rato_rds")

db_connection <- db_connect(myconfig)


dim_weather_station <- db_query(db_connection, query_sql = "select * from dim_weather_station")
fct_daily_temperature <- db_query(db_connection, query_sql = "select * from fct_daily_temperature")

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
db_disconnect(db_connection)
