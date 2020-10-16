library("RMySQL")
library(rstudioapi)
library(tidyverse)


conn_staging <- dbConnect(RMySQL::MySQL(), 
                          user = 'admin', 
                          password = 'password', 
                          port = 3306,
                          dbname = 'dsp_db',
                          host = 'mysql-instance1.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

## Get staging records
stg_rows <- dbSendQuery(conn_staging, "select * from solar_system_cost;
")
## transform into dataframe
df_staging <- fetch(stg_rows)

## disconnect mysql server
# dbDisconnect(conn_staging)

# ################################################
# Ready to load into DIM table
# dwh_user <- askForPassword('Type in user for DWH RDS...')
# dwh_passwd <- askForPassword('Type in password for DWH RDS...')
# Create a connection Object to MySQL database.
# conn_dwh <- dbConnect(RMySQL::MySQL(),
#                       user = 'tutorial_user',
#                       password = 'password',
#                       port = 3306,
#                       dbname = 'dsp_test',
#                       host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

# curr_dim <- dbReadTable(conn_staging,"dim_sys_cost")

# Wrangling of dataframe into the right form to store in SQL
df_staging$dim_created_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
df_staging$dim_updated_date <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

# Save Records into DIM table
# dbExecute(conn_dwh,"start transaction;")
dbWriteTable(conn_staging,"dim_sys_cost",df_staging, append=TRUE, row.names=FALSE)

# dbExecute(conn_dwh,"commit;")

dbDisconnect(conn_staging)
