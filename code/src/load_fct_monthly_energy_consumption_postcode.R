library(readr)
library(here)
library(reshape2)
library(knitr)
library(tidyverse)
source(here("code/common", "mysql_connection.R"))

remove(list = ls())

# get data
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection <- db_connect(root_config)

df_staging <- read.csv(here("data", "Energy_consumption_data.csv")) %>%
  filter(Category!="Council") %>%
  filter(`Data.Type`!='Total Energy (kWh)') %>%
  select(-Category)

colnames(df_staging) <- c("postcode"
                          ,"customer_type"
                          ,"year"
                          ,"data_type"
                          ,"1"
                          ,"2"
                          ,"3"
                          ,"4"
                          ,"5"
                          ,"6"
                          ,"7"
                          ,"8"
                          ,"9"
                          ,"10"
                          ,"11"
                          ,"12"
)

df_staging$postcode <- as.factor(str_pad(df_staging$postcode,4,pad = '0'))
df_staging_pc <- df_staging %>% 
  gather(month, value, `1`:`12`) %>%
  spread(data_type, value)
colnames(df_staging_pc) <- c("postcode"
                             ,"customer_type"
                             ,"year"
                             ,"month"
                             ,"customer_count"
                             ,"daily_energy_per_customer_kWh"
                             )
df_staging_pc$month <- as.numeric(df_staging_pc$month)

dim_postcode <- db_query(db_connection, query_sql = "select * from dim_postcode;")

# process data
df_write <- df_staging_pc %>%
  left_join(dim_postcode, by = "postcode") %>%
  filter(is.na(dim_postcode_key) == FALSE) %>%
  select("dim_postcode_key","customer_type","year","month","customer_count", "daily_energy_per_customer_kWh") %>%
  arrange(dim_postcode_key, `year`,month)

# ----------------------------------------------------------------------
# insert data to the public rds server
db_write(db_connection, table_name = "fct_monthly_energy_consumption_postcode", dataset = df_write)
db_disconnect(db_connection)
