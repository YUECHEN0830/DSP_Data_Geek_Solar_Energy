library("RMySQL")
library(rstudioapi)
library(tidyverse)

################################################
# connect to Staging DB
stg_user <- askForPassword('Type in user for Staging RDS...')
stg_passwd <- askForPassword('Type in password for Staging RDS...')
# Create a connection Object to MySQL database.
conn_staging <- dbConnect(RMySQL::MySQL(), 
                          user = stg_user, 
                          password = stg_passwd, 
                          port = 3306,
                          dbname = 'db_dsp01',
                          host = 'dsp-01.cnk9sarev6lg.us-east-2.rds.amazonaws.com')

## Get staging records
stg_rows <- dbSendQuery(conn_staging, "select * from stg_solar_panels;")
## transform into dataframe
df_staging <- fetch(stg_rows)
df_staging$Model <- str_replace(str_replace(df_staging$Model, 'Table 2: ', ''), ' technical specifications', '')

## disconnect mysql server
dbDisconnect(conn_staging)

################################################
# Ready to load into DIM table
dwh_user <- askForPassword('Type in user for DWH RDS...')
dwh_passwd <- askForPassword('Type in password for DWH RDS...')
# Create a connection Object to MySQL database.
conn_dwh <- dbConnect(RMySQL::MySQL(), 
                      user = dwh_user, 
                      password = dwh_passwd, 
                      port = 3306,
                      dbname = 'dsp_test',
                      host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

curr_dim <- dbReadTable(conn_dwh,"dim_solar_panel")

# Wrangling of dataframe into the right form to store in SQL
# dim_created_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
# dim_updated_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
# df_dates <- data.frame(dim_created_date, dim_updated_date)
df_stg <- df_staging %>%
  # select(-value, -fin_year) %>%
  distinct() %>%
  arrange(Manufacturer, Model)
df_load <- df_stg %>%
  left_join(curr_dim, by=c('Model')) %>%
  filter(is.na(dim_solar_panel_key)==TRUE)
df_load <- df_load %>%
  select(colnames(df_load[,1:13]))
colnames(df_load) <- sub(".x", "", colnames(df_load))

# Save Records into DIM table
dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_dwh,"dim_solar_panel",df_load, append=TRUE, row.names=FALSE)
#dbExecute(conn_dwh,"insert into myRealTable(a,b,c) select a,b,c from myTempTable")
#dbExecute(conn_dwh,"drop table if exists myTempTable")
dbExecute(conn_dwh,"commit;")
