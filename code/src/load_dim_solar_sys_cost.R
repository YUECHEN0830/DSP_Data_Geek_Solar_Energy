library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "yukai_root")
db_connection <- db_connect(root_config)

df_write <- db_query(db_connection, query_sql = "select * from solar_system_cost;")
head(df_write)

db_disconnect(db_connection)

# ----------------------------------------------------------------------

# insert data to the public rds server
config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection_2 <- db_connect(config)

# insert data
db_write(db_connection_2, table_name = "dim_solar_sys_cost", dataset = df_write)
db_disconnect(db_connection_2)
