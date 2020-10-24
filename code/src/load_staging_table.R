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

# Import Tables
stg_ausgrid_average_201718 <- read_csv('/Users/marco/UTS/DSP/AT2/Data/stg_ausgrid_average_201718.csv')
dbWriteTable(conn_staging,"stg_ausgrid_average_201718", stg_ausgrid_average_201718, append=TRUE, row.names=FALSE)

stg_ausgrid_average_201819 <- read_csv('/Users/marco/UTS/DSP/AT2/Data/stg_ausgrid_average_201819.csv')
dbWriteTable(conn_staging,"stg_ausgrid_average_201819", stg_ausgrid_average_201819, append=TRUE, row.names=FALSE)

# List the tables available in this database.
dbListTables(conn_staging)

# Query the "t1" tables to get all the rows.
ausgr_201718 <- dbSendQuery(conn_staging, "SELECT * FROM stg_ausgrid_average_201718")
datasets <- fetch(ausgr_201718)



# disconnect mysql server
dbDisconnect(conn_staging)


