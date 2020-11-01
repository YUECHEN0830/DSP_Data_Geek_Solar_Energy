library(readr)
library(here)
library(reshape2)
library(knitr)
library(dplyr)
source(here("code/common", "mysql_connection.R"))

# get data
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection <- db_connect(root_config)

df_staging <- read.csv(here("data", "Solar_Installation_Data.csv"))
df_staging <- df_staging %>%
  filter(POSTCODE!="Grand Total") %>%
  select(-c("SUBURB", "NMI.", "INVERTER.CAPACITY")) %>%
  distinct(POSTCODE) %>%
  mutate(state="QLD")

colnames(df_staging) <- c("postcode","state")

dim_postcode <- db_query(db_connection, query_sql = "select * from dim_postcode;")

# process data
df_write <- df_staging %>%
  left_join(dim_postcode, by = "postcode") %>%
  filter(is.na(dim_postcode_key) == TRUE) %>%
  select(c("postcode","state.x")) %>%
  arrange(postcode)
df_write <- rename(df_write, c("state" = "state.x"))

# ----------------------------------------------------------------------
# insert data to the public rds server
db_write(db_connection, table_name = "dim_postcode", dataset = df_write)
db_disconnect(db_connection)
