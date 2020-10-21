library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
db_connection <- db_connect(username = 'admin', password = 'password', dbname = 'dsp_db', host = 'mysql-instance1.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

df_capacity <- db_query(db_connection, query_sql = "select * from ANNUAL_INSTALLED_CAPACITY_OF_SOLAR_PV;")
colnames(df_capacity)[1] <- "year"

dim_aus_state <- db_query(db_connection, query_sql = "select * from dim_aus_state;")

# process data
df_capacity_2 <- melt(df_capacity, id.vars=c("year"), variable.name="state_short_code", value.name="mw_installed")

df_write <- inner_join(df_capacity_2, dim_aus_state, by = c("state_short_code" = "short_code")) %>%
  select("dim_aus_state_key", "year", "mw_installed") %>%
  arrange(year, dim_aus_state_key)
head(df_write)

# insert data
db_write(db_connection, table_name = "fct_annual_installed_capacity", dataset = df_write)
db_disconnect(db_connection)


