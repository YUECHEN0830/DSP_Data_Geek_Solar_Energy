library(here)
source(here("code/common", "mysql_connection.R"))


db_connection <- db_connect(username = 'admin', password = 'password', dbname = 'dsp_db', host = 'mysql-instance1.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

df <- db_query(db_connection, "select * from solar_PV_system_output")
head(df, 2)

db_disconnect(db_connection)