library(readr)
library(here)
library(reshape2)
library(knitr)
library(tidyverse)
library(httr)
library(jsonlite)
library(lubridate)
source(here("code/common", "mysql_connection.R"))

remove(list = ls())

# get data - from Solcast API
lat <- -33.86882
long <- 151.209295

# get Solar Radiation at Lat and Long
tf <- here("data\\solcast", format(Sys.time(), paste("Radiation_",lat,'_',long,"_%Y%m%d-%H%M%S.json",sep='')))

result <- GET("https://api.solcast.com.au/world_radiation/estimated_actuals"
              , query = list(
                api_key=Sys.getenv("solcast")
                ,latitude=lat
                ,longitude=long
                ,hours=168
                ,format="json")
              , write_disk(tf)
)

df_solcast <- jsonlite::fromJSON(tf, simplifyVector = TRUE)$"estimated_actuals"

# get Solar Radiation at Lat and Long
tf <- here("data\\solcast", format(Sys.time(), paste("PV_Power_",lat,'_',long,"_%Y%m%d-%H%M%S.json",sep='')))
result <- GET("https://api.solcast.com.au/world_pv_power/estimated_actuals"
              , query = list(
                api_key=Sys.getenv("solcast")
                ,latitude=lat
                ,longitude=long
                ,capacity=5
                ,tilt=30
                ,azimuth=0
                ,hours=168
                ,format="json")
              , write_disk(tf, overwrite =FALSE)
)

df_pv_power <- jsonlite::fromJSON(tf, simplifyVector = TRUE)$"estimated_actuals"

# Connect to DWH
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection <- db_connect(root_config)

df_staging <- df_solcast %>%
  left_join(df_pv_power, by=c("period_end")) %>%
  select(-period.x, -period.y) %>%
  mutate(latitude=lat
         ,longitude=long
         ,period_end_local=with_tz(strptime(period_end, format="%Y-%m-%dT%H:%M", tz="UTC"), tzone = Sys.timezone())
         ) %>%
  mutate(
    dim_date_key=as.numeric(str_replace_all(substring(as.character(period_end_local),1,10),'-',''))
    ,hour_min=substring(period_end_local,12,16)
  ) %>%
  select(-period_end_local,-period_end)

df_fct <- db_query(db_connection, query_sql = "select * from fct_periodic_world_radiation_solcast_estimated;")

df_write <- df_staging %>%
  left_join(df_fct, by=c("dim_date_key","latitude","longitude")) %>%
  filter(is.na(fct_periodic_world_radiation_solcast_estimated_key) == TRUE) %>%
  select(-fct_periodic_world_radiation_solcast_estimated_key:pv_estimate.y)
colnames(df_write) <- c(
  "ghi"
  ,"ebh"
  ,"dni"
  ,"dhi"
  ,"cloud_opacity"
  ,"pv_estimate"
  ,"latitude"
  ,"longitude"
  ,"dim_date_key"
  ,"hour_min"
)
# ----------------------------------------------------------------------
# insert data to the public rds server
db_write(db_connection, table_name = "fct_periodic_world_radiation_solcast_estimated", dataset = df_write)
db_disconnect(db_connection)
