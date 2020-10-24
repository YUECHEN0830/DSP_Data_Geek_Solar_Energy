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


# List the tables available in this database.
dbListTables(conn_staging)

# Query the "t1" tables to get all the rows.
result <- dbSendQuery(conn_staging, "select * from stg_ausgrid_average_201718_new2")
datasets <- fetch(result)

# Import Table
frame <- read_csv('/Users/marco/UTS/DSP/AT2/Data/stg_ausgrid_average_201718.csv')
dbWriteTable(conn_staging,"stg_ausgrid_average_201718_new2", frame, append=TRUE, row.names=FALSE)


# disconnect mysql server
dbDisconnect(conn_staging)


