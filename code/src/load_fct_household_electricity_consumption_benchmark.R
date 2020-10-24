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
stg_rows <- dbSendQuery(conn_staging, "select * from stg_electricity_consumption_benchmarks;")
## transform into dataframe
df_staging <- fetch(stg_rows)
df_staging$`Spring kWh` <- str_replace(df_staging$`Spring kWh`, '\r', '')

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

dim_aus_state <- dbReadTable(conn_dwh,"dim_aus_state")
dim_climate_zone <- dbReadTable(conn_dwh,"dim_climate_zone")
dim_household_size <- dbReadTable(conn_dwh,"dim_household_size")

# Wrangling of dataframe into the right form to store in SQL
# dim_created_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
# dim_updated_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
# df_dates <- data.frame(dim_created_date, dim_updated_date)
df_stg <- df_staging %>%
  # select(-value, -fin_year) %>%
  # distinct() %>%
  arrange(State, `Climate Zone`, `Swimming Pool?`, `Household Size`)
df_stg$`Climate Zone` <- str_replace(df_stg$`Climate Zone`, ' electricity benchmarks', '')
df_load <- df_stg %>%
  left_join(dim_aus_state, by=c('State' = 'state')) %>%
  left_join(dim_climate_zone, by=c('Climate Zone' = 'climate_zone')) %>%
  left_join(dim_household_size, by=c('Household Size' = 'household_size'))
df_load <- df_load %>%
  select(-c('State', 'Climate Zone', 'Household Size', 'dim_created_date.x', 'dim_updated_date.x', 'dim_created_date.y', 'dim_updated_date.y', 'dim_created_date', 'dim_updated_date'))
df_load$`Autumn kWh` <- as.integer(df_load$`Autumn kWh`)
df_load$`Summer kWh` <- as.integer(df_load$`Summer kWh`)
df_load$`Winter kWh` <- as.integer(df_load$`Winter kWh`)
df_load$`Spring kWh` <- as.integer(df_load$`Spring kWh`)
df_load$`Swimming Pool?` <- str_replace(df_load$`Swimming Pool?`, 'N/A', 'A')

df_load <- cbind(select(df_load, c('dim_aus_state_key','dim_climate_zone_key','dim_household_size_key','Swimming Pool?')),select(df_load, -c('dim_aus_state_key','dim_climate_zone_key','dim_household_size_key','Swimming Pool?')))
df_load <- df_load %>% rename('swimming_pool_ind' = 'Swimming Pool?', 'autumn_kWh' = 'Autumn kWh', 'summer_kWh' = 'Summer kWh', 'winter_kWh' = 'Winter kWh', 'spring_kWh' = 'Spring kWh')
# Save Records into DIM table
dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_dwh,"fct_household_electricity_consumption_benchmark",df_load, append=TRUE, row.names=FALSE)
#dbExecute(conn_dwh,"insert into myRealTable(a,b,c) select a,b,c from myTempTable")
#dbExecute(conn_dwh,"drop table if exists myTempTable")
dbExecute(conn_dwh,"commit;")
