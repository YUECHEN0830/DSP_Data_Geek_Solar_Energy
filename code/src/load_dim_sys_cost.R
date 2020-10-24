library(here)
source(here("code/common", "mysql_connection.R"))

db_connection <- db_connect(username = 'root', password = 'password', dbname = 'DSP_AT2', host = 'localhost')
df_cost <- db_query(db_connection, query_sql = "select * from solar_system_cost;")

db_write(db_connection, table_name = "dim_sys_cost", dataset = df_cost)
db_disconnect(db_connection)
