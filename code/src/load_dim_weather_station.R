library("RMySQL")
library(rstudioapi)
library(tidyverse)
library(here)

################################################
# connect to Staging DB
# Create a connection Object to MySQL database.
conn_staging <- dbConnect(RMySQL::MySQL(), 
                          user = Sys.getenv("stg_username"), 
                          password = Sys.getenv("stg_password"), 
                          port = 3306,
                          dbname = 'dsp_test',
                          host = 'dsp-01.cnk9sarev6lg.us-east-2.rds.amazonaws.com')

## Get staging records
stg_rows <- dbSendQuery(conn_staging, "select
	right(concat('0000',Site), 6) as station_number
	,Name as station_name
	,Lat as latitude
	,Lon as longitude
	,`Start Year` as start_year
	,case `Start Month`
		when 'Jan' then 1
		when 'Feb' then 2
		when 'Mar' then 3
		when 'Apr' then 4
		when 'May' then 5
		when 'Jun' then 6
		when 'Jul' then 7
		when 'Aug' then 8
		when 'Sep' then 9
		when 'Oct' then 10
		when 'Nov' then 11
		when 'Dec' then 12
	end as start_month
	,`End Year` as end_year
	,case `End Month`
		when 'Jan' then 1
		when 'Feb' then 2
		when 'Mar' then 3
		when 'Apr' then 4
		when 'May' then 5
		when 'Jun' then 6
		when 'Jul' then 7
		when 'Aug' then 8
		when 'Sep' then 9
		when 'Oct' then 10
		when 'Nov' then 11
		when 'Dec' then 12
	end as end_month
from stg_Weather_Stations
;")
## transform into dataframe
df_staging <- fetch(stg_rows)

## disconnect mysql server
dbDisconnect(conn_staging)

df_staging <- read.csv(here("data/Bureau of Meteorology", "One Minute Solar Data - List of stations.csv"))
colnames(df_staging) <- c('station_number','station_name','start_year','end_year','year_old')
df_staging$station_number <- as.factor(str_pad(df_staging$station_number,6,pad = '0'))
################################################
# Ready to load into DIM table
# Create a connection Object to MySQL database.
conn_dwh <- dbConnect(RMySQL::MySQL(), 
                      user = Sys.getenv("dwh_username"), 
                      password = Sys.getenv("dwh_password"), 
                      port = 3306,
                      dbname = 'dsp_test',
                      host = 'dsp-01.cnk9sarev6lg.us-east-2.rds.amazonaws.com')

curr_dim <- dbReadTable(conn_dwh,"dim_weather_station")

# Wrangling of dataframe into the right form to store in SQL
df_stg <- df_staging %>%
  # select(-value, -fin_year) %>%
  distinct() %>%
  arrange(station_number)
df_load <- df_stg %>%
  left_join(curr_dim, by='station_number') %>%
  filter(is.na(dim_weather_station_key)==TRUE)
df_load <- df_load %>%
  select(colnames(df_load[,1:4]))
colnames(df_load) <- sub(".x", "", colnames(df_load))


# Save Records into DIM table
dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_dwh,"dim_weather_station",df_load, append=TRUE, row.names=FALSE)
dbExecute(conn_dwh,"commit;")
