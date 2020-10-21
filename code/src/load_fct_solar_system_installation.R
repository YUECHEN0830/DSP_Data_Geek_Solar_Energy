library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
db_connection <- db_connect(username = 'admin', password = 'password', dbname = 'dsp_db', host = 'mysql-instance1.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

df_installation <- db_query(db_connection, query_sql = "select * from ANNUAL_SOLAR_PV_INSTALLATIONS")
colnames(df_installation)[1] <- "year"

dim_aus_state <- db_query(db_connection, query_sql = "select * from dim_aus_state;")

# process data
df_installation_2 <- melt(df_installation, id.vars=c("year"), variable.name="state_short_code", value.name="number_of_installation")

df_write <- inner_join(df_installation_2, dim_aus_state, by = c("state_short_code" = "short_code")) %>%
  select("dim_aus_state_key", "year", "number_of_installation") %>%
  arrange(year, dim_aus_state_key)
head(df_write)

# insert data
db_write(db_connection, table_name = "fct_sys_installation", dataset = df_write)
db_disconnect(db_connection)



