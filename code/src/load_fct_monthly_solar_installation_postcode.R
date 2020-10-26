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

df_staging <- read.csv(here("data", "Postcode data for small-scale installations - sgu - solar panel.csv"))
colnames(df_staging) <- c("postcode"
                          ,"2019-01 installations_count","2019-01 rated_output_kW"
                          ,"2019-02 installations_count","2019-02 rated_output_kW"
                          ,"2019-03 installations_count","2019-03 rated_output_kW"
                          ,"2019-04 installations_count","2019-04 rated_output_kW"
                          ,"2019-05 installations_count","2019-05 rated_output_kW"
                          ,"2019-06 installations_count","2019-06 rated_output_kW"
                          ,"2019-07 installations_count","2019-07 rated_output_kW"
                          ,"2019-08 installations_count","2019-08 rated_output_kW"
                          ,"2019-09 installations_count","2019-09 rated_output_kW"
                          ,"2019-10 installations_count","2019-10 rated_output_kW"
                          ,"2019-11 installations_count","2019-11 rated_output_kW"
                          ,"2019-12 installations_count","2019-12 rated_output_kW"
                          ,"2020-01 installations_count","2020-01 rated_output_kW"
                          ,"2020-02 installations_count","2020-02 rated_output_kW"
                          ,"2020-03 installations_count","2020-03 rated_output_kW"
                          ,"2020-04 installations_count","2020-04 rated_output_kW"
                          ,"2020-05 installations_count","2020-05 rated_output_kW"
                          ,"2020-06 installations_count","2020-06 rated_output_kW"
                          ,"2020-07 installations_count","2020-07 rated_output_kW"
                          ,"2020-08 installations_count","2020-08 rated_output_kW"
)
df_staging$postcode <- as.factor(str_pad(df_staging$postcode,4,pad = '0'))
df_staging_pc <- df_staging %>% 
  melt(id.vars="postcode")
df_staging_pc$variable <- as.character(df_staging_pc$variable)
df_staging_pc <- df_staging_pc %>% 
  mutate(`year`=as.integer(substr(df_staging_pc$variable,1,4)))
df_staging_pc <- df_staging_pc %>% 
  mutate(`month`=as.integer(substr(df_staging_pc$variable,6,7)))
df_staging_pc <- df_staging_pc %>% 
  mutate(type=substr(df_staging_pc$variable,9,length(df_staging_pc$variable)))
df_staging_pc$value <- as.numeric(df_staging_pc$value)
df_staging_pc <- select(df_staging_pc, -variable)
df_staging_pc <- spread(df_staging_pc, type, value )

dim_postcode <- db_query(db_connection, query_sql = "select * from dim_postcode;")

# process data
df_write <- df_staging_pc %>%
  left_join(dim_postcode, by = "postcode") %>%
  filter(is.na(dim_postcode_key) == FALSE) %>%
  select("dim_postcode_key","year", "month", "installations_count", "rated_output_kW") %>%
  arrange(dim_postcode_key, `year`,month)

# ----------------------------------------------------------------------
# insert data to the public rds server
db_write(db_connection, table_name = "fct_monthly_solar_installation_postcode", dataset = df_write)
db_disconnect(db_connection)
