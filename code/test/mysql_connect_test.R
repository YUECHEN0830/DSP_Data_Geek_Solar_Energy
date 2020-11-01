library("RMySQL")

# Create a connection Object to MySQL database.
mysqlconnection <- dbConnect(RMySQL::MySQL(), 
                            user = 'tutorial_user', 
                            password = 'password', 
                            port = 3306,
                            dbname = 'dsp_test',
                            host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com')


# List the tables available in this database.
dbListTables(mysqlconnection)

# Query the "t1" tables to get all the rows.
result <- dbSendQuery(mysqlconnection, "select * from t1")
datasets <- fetch(result)

# disconnect mysql server
dbDisconnect(mysqlconnection)
