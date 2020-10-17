library("RMySQL")

db_connection <- function(username = 'tutorial_user', password = 'password') {
  
  mysqlconnection <- dbConnect(RMySQL::MySQL(), 
                               user = username, 
                               password = password, 
                               port = 3306,
                               dbname = 'dsp_test',
                               host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com');
  return(mysqlconnection);
}


db_disconnect <- function(mysqlconnection) {
  dbDisconnect(mysqlconnection)
}
