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
colnames(df_staging) <- c("postcode","suburb","nmi#","inverter_capacity")
df_staging$dim_date_key <- 20200201

dim_postcode_suburb <- db_query(db_connection, query_sql = "select * from dim_postcode_suburb;")
dim_postcode_suburb$suburb <- toupper(dim_postcode_suburb$suburb)

# process data
df_write <- df_staging %>%
  left_join(dim_postcode_suburb, by = c("postcode" = "postcode", "suburb" = "suburb")) %>%
  select("dim_postcode_suburb_key","dim_postcode_suburb_key", "dim_date_key", "nmi#", "inverter_capacity") %>%
  filter(is.na(dim_postcode_suburb_key) == FALSE) %>%
  arrange(dim_postcode_suburb_key)

# ----------------------------------------------------------------------
# insert data to the public rds server
db_write(db_connection, table_name = "fct_solar_installation", dataset = df_write)
db_disconnect(db_connection)
