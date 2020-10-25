library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "yukai_root")
db_connection <- db_connect(root_config)

df_output <- db_query(db_connection, query_sql = "select * from solar_PV_system_output;")
df_output <- df_output[-1,]
df_output$`Solar system size` <- as.numeric(df_output$`Solar system size`)
head(df_output)

# names(df_output) <- c("state", "city", "size", "avg_daily_output")

db_disconnect(db_connection)

# ----------------------------------------------------------------------

# insert data to the public rds server
public_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection_2 <- db_connect(public_config)

df_cost <- db_query(db_connection_2, query_sql = "select * from dim_solar_sys_cost;")
dim_aus_state <- db_query(db_connection_2, query_sql = "select * from dim_aus_state;")

df_write <- df_output %>%
  left_join(df_cost, by = c("Solar system size" = "system_size")) %>%
  inner_join(dim_aus_state, by = c("State" = "short_code")) %>%
  select("dim_aus_state_key", "City", "dim_solar_sys_cost_key", "Avg daily system output") %>%
  arrange(dim_aus_state_key)

names(df_write) <- c("dim_aus_state_key", "city", "dim_solar_sys_cost_key", "avg_daily_output")
head(df_write)

# insert data
db_write(db_connection_2, table_name = "fct_solar_pv_sys_output", dataset = df_write)
db_disconnect(db_connection_2)


