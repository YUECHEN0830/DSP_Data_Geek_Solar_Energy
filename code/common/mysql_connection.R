library(RMySQL)

# Get database connection
db_connect <- function(username = 'tutorial_user', 
                          password = 'password',
                          port = 3306,
                          dbname = 'dsp_test',
                          host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com') {
    
  mysqlconnection <- dbConnect(RMySQL::MySQL(),
                               user = username,
                               password = password,
                               port = port,
                               dbname = dbname,
                               host = host)

  return (mysqlconnection)
}

# Disconnect database
db_disconnect <- function(db_connection) {
  dbDisconnect(db_connection)
}

# Query
db_query <- function(db_connection, query_sql) {
  df <- dbGetQuery(db_connection, query_sql)
  return (df)
}

# Insert / update data
db_write <- function(db_connection, table_name, dataset) {
  dbWriteTable(db_connection, table_name, dataset, append=TRUE, row.names=FALSE)
}
