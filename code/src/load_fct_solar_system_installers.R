library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "yukai_root")
db_connection <- db_connect(root_config)

df_installers <- db_query(db_connection, query_sql = "select * from TOTAL_NUMBER_OF_ACCREDITED_INSTALLERS_AND_DESIGNERS;")
colnames(df_installers)[1] <- "year"

dim_aus_state <- db_query(db_connection, query_sql = "select * from dim_aus_state;")

# process data
df_installers_2 <- melt(df_installers, id.vars=c("year"), variable.name="state_short_code", value.name="num_accredited_installers")

df_write <- inner_join(df_installers_2, dim_aus_state, by = c("state_short_code" = "short_code")) %>%
  select("dim_aus_state_key", "year", "num_accredited_installers") %>%
  arrange(year, dim_aus_state_key)
head(df_write)

db_disconnect(db_connection)

# ----------------------------------------------------------------------

# insert data to the public rds server
config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection_2 <- db_connect(config)

# insert data
db_write(db_connection_2, table_name = "fct_annual_accredited_installers", dataset = df_write)
db_disconnect(db_connection_2)


