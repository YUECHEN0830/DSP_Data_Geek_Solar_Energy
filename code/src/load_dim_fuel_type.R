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
stg_rows <- dbSendQuery(conn_staging, "select fuel_group, fuel_type, `2008-09` value, 2009 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2009-10` value, 2010 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2010-11` value, 2011 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2011-12` value, 2012 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2012-13` value, 2013 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2013-14` value, 2014 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2014-15` value, 2015 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2015-16` value, 2016 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2016-17` value, 2017 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2017-18` value, 2018 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2018-19` value, 2019 fin_year
from stg_DISER_TableO_NSW
;
")
## transform into dataframe
df_staging <- fetch(stg_rows)

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

curr_dim <- dbReadTable(conn_dwh,"dim_fuel_type")

# Wrangling of dataframe into the right form to store in SQL
dim_created_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
dim_updated_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
df_dates <- data.frame(dim_created_date, dim_updated_date)
df_stg <- df_staging %>%
  select(-value, -fin_year) %>%
  distinct() %>%
  arrange(fuel_group, fuel_type)
df_load <- cbind(df_dates, df_stg) %>%
  left_join(curr_dim, by=c('fuel_type')) %>%
  filter(is.na(dim_fuel_type_key)==TRUE)
df_load <- df_load %>%
  select(colnames(df_load[,1:4]))
colnames(df_load) <- sub(".x", "", colnames(df_load))

# Save Records into DIM table
dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_dwh,"dim_fuel_type",df_load, append=TRUE, row.names=FALSE)
#dbExecute(conn_dwh,"insert into myRealTable(a,b,c) select a,b,c from myTempTable")
#dbExecute(conn_dwh,"drop table if exists myTempTable")
dbExecute(conn_dwh,"commit;")
