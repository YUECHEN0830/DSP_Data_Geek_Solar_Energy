library(here)
source(here("code/common", "mysql_connection.R"))

db_connection <- db_connect(username = 'root', password = 'password', dbname = 'DSP_AT2', host = 'localhost')
df_output <- db_query(db_connection, 
                      query_sql = "
                          select 
                            t1.dim_aus_state_key,  
                            t2.city, 
                            t2.`Solar system size` size, 
                            t2.`Avg daily system output` avg_daily_output 
                          from 
                            dim_aus_state t1, solar_PV_system_output t2 
                          where 
                            t1.short_code = t2.State 
                          order by t1.dim_aus_state_key;"
)

db_write(db_connection, table_name = "fct_solar_pv_sys_output", dataset = df_output)
db_disconnect(db_connection)
