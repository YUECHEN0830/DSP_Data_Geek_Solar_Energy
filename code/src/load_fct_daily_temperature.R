library(readr)
library(here)
library(reshape2)
library(knitr)
library(tidyverse)

remove(list = ls())

source(here("code/common", "mysql_connection.R"))

################################################
# connect to Staging DB
## Get staging records
station_nbr <- '39083'

stg_max <- read.csv(here("data/raw_datasets/BOM_Temperature", paste("IDCJAC0010_",station_nbr,"_2020_Data.csv",sep="")))
stg_max$Bureau.of.Meteorology.station.number <- as.factor(str_pad(stg_max$Bureau.of.Meteorology.station.number,6,pad = '0'))
stg_max$dim_date_key <- as.integer(paste(stg_max$Year,str_pad(stg_max$Month,2,pad = '0'),str_pad(stg_max$Day,2,pad = '0'),sep = ""))
stg_max <- stg_max %>%
  arrange(Bureau.of.Meteorology.station.number, dim_date_key)
stg_max <- rename(stg_max, c('max_temperature' = 'Maximum.temperature..Degree.C.'))  

stg_min <- read.csv(here("data/raw_datasets/BOM_Temperature", paste("IDCJAC0011_",station_nbr,"_2020_Data.csv",sep="")))
stg_min$Bureau.of.Meteorology.station.number <- as.factor(str_pad(stg_min$Bureau.of.Meteorology.station.number,6,pad = '0'))
stg_min$dim_date_key <- as.integer(paste(stg_min$Year,str_pad(stg_min$Month,2,pad = '0'),str_pad(stg_min$Day,2,pad = '0'),sep = ""))
stg_min <- stg_min %>%
  arrange(Bureau.of.Meteorology.station.number, dim_date_key)
stg_min <- rename(stg_min, c('min_temperature' = 'Minimum.temperature..Degree.C.'))  

stg_rows <- stg_max %>%
  full_join(stg_min, by=c('Bureau.of.Meteorology.station.number', 'dim_date_key'))
################################################
# Ready to load into DIM table
# Create a connection Object to MySQL database.
# Create a connection Object to MySQL database.
config <- read.csv(here("code/config", "db_connection_config.csv"))
myconfig <- config %>% filter(user_key == "rato_rds")

db_connection <- db_connect(myconfig)

dim_weather_station <- db_query(db_connection, query_sql = "select * from dim_weather_station")
fct_daily_temperature <- db_query(db_connection, query_sql = "select * from fct_daily_temperature")

df_stg <- stg_rows %>%
  arrange(Bureau.of.Meteorology.station.number, dim_date_key)
df_load <- df_stg %>%
  left_join(dim_weather_station, by=c('Bureau.of.Meteorology.station.number' = 'station_number')) %>%
  left_join(fct_daily_temperature, by=c('dim_weather_station_key','dim_date_key'))
df_load <- df_load %>%
  filter(is.na(fct_daily_temperature_key)==TRUE) %>%
  select(c('dim_weather_station_key', 'dim_date_key', 'min_temperature.x', 'max_temperature.x'))
df_load <- df_load %>%
  rename("min_temperature" = "min_temperature.x") %>%
  rename("max_temperature" = "max_temperature.x")
  
# Save Records into DIM table
# dbExecute(db_connection,"start transaction;")
dbWriteTable(db_connection,"fct_daily_temperature",df_load, append=TRUE, row.names=FALSE)
db_disconnect(db_connection)
