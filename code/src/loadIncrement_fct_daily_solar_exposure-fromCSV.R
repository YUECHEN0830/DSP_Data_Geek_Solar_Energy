library("RMySQL")
library(rstudioapi)
library(tidyverse)

################################################
dwh_user <- Sys.getenv("dwh_username")
dwh_passwd <- Sys.getenv("dwh_password")
dwh_dbname <- 'dsp_test'
dwh_host <- 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com'

# get data
df_staging <- read.csv('N:\\Data_Work\\20200802 94692 Data Science Practices\\AT2\\DSP_Data_Geek_Solar_Energy\\data\\Bureau of Meteorology\\IDCJAC0016_066062_1800_Data.csv')
df_staging$Bureau.of.Meteorology.station.number <- str_sub(paste('0000',as.factor(df_staging$Bureau.of.Meteorology.station.number),sep=''),-6,-1)
df_staging$Year <- as.factor(df_staging$Year)
df_staging$Month <- str_sub(paste('0',as.factor(df_staging$Month),sep = ''),-2,-1)
df_staging$Day <- str_sub(paste('0',as.factor(df_staging$Day),sep = ''),-2,-1)
df_staging$dim_date_key <- as.integer(paste(df_staging$Year,df_staging$Month,df_staging$Day,sep = ''))
df_staging <- rename(df_staging
                     ,'station_number' = 'Bureau.of.Meteorology.station.number'
                     ,'daily_exposure' = 'Daily.global.solar.exposure..MJ.m.m.')
df_staging <- df_staging %>%
  select(-c('Product.code','Year','Month','Day'))

################################################
# connect to DWH DB
db_connection <- db_connect(username = dwh_user, password = dwh_passwd, dbname = dwh_dbname, host = dwh_host)

################################################
dim_weather_station <- dbReadTable(db_connection,"dim_weather_station")
fct_daily_solar_exposure <- dbReadTable(db_connection,"fct_daily_solar_exposure")

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
dbExecute(db_connection,"start transaction;")
dbWriteTable(db_connection,"fct_daily_solar_exposure",df_load, append=TRUE, row.names=FALSE)
dbExecute(db_connection,"commit;")
