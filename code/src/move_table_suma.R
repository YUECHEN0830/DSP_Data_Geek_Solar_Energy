library("RMySQL")
library(rstudioapi)
library(tidyverse)

################################################

# connect to Staging DB
stg_user <- askForPassword('Type user for Staging RDS...')
stg_passwd <- askForPassword('Type password for Staging RDS...')

# Create a connection Object to MySQL database.
conn_staging <- dbConnect(RMySQL::MySQL(), 
                          user = stg_user, 
                          password = stg_passwd, 
                          port = 3306,
                          dbname = 'dsp_at2_staging',
                          host = 'dsp.c0jjwwn9tcr5.us-east-2.rds.amazonaws.com')

## Get staging records Staging DB
q_ausgr_201718 <- dbSendQuery(conn_staging, "SELECT * FROM stg_ausgrid_average_201718")
ausgr_201718 <- fetch(q_ausgr_201718)

q_ausgr_201819 <- dbSendQuery(conn_staging, "SELECT * FROM stg_ausgrid_average_201819")
ausgr_201819 <- fetch(q_ausgr_201819)


## Wrangle Staging to Dim and Fact tabel 



## disconnect mysql server
dbDisconnect(conn_staging)



################################################

# Ready to load into DIM table
dwh_user <- askForPassword('Type user for DWH RDS...')
dwh_passwd <- askForPassword('Type password for DWH RDS...')

# Create a connection Object to MySQL database.
conn_dwh <- dbConnect(RMySQL::MySQL(), 
                      user = dwh_user, 
                      password = dwh_passwd, 
                      port = 3306,
                      dbname = 'dsp_test',
                      host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

# Import Tables to DWH
dbWriteTable(conn_dwh,"stg_ausgrid_average_201718", stg_ausgrid_average_201718, append=TRUE, row.names=FALSE)
dbWriteTable(conn_dwh,"stg_ausgrid_average_201819", stg_ausgrid_average_201819, append=TRUE, row.names=FALSE)

## disconnect mysql server
dbDisconnect(conn_dwh)