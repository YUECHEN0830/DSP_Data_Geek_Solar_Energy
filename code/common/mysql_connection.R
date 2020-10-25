library(RMySQL)

# Get database connection
db_connect <- function(db_config) {
  
  mysqlconnection <- dbConnect(RMySQL::MySQL(),
                               user = db_config$username,
                               password = db_config$password,
                               port = db_config$port,
                               dbname = db_config$dbname,
                               host = db_config$host)
  
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
