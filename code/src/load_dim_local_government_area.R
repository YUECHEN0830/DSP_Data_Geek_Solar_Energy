library("RMySQL")
library(rstudioapi)
library(tidyverse)
library(here)

# using configuration file
config <- read.csv(here("code/config", "db_connection_config.csv"))
myconfig <- config %>% filter(user_key == "rato_rds")

################################################
# connect to Staging DB
db_connection <- db_connect(myconfig)

sql_staging <- 'select distinct 
	*
	,2018 as `year`
from dsp_test.stg_ausgrid_average_201718
where 1=1
and local_government_area is not null
UNION 
select distinct 
	*
	,2019 as `year`
from dsp_test.stg_ausgrid_average_201819
where 1=1
and local_government_area is not null
;
'

## Get staging records
df_staging <- db_query(db_connection, query_sql = sql_staging)

################################################
# Ready to load into DIM table
curr_dim <- dbReadTable(db_connection,"dim_local_government_area")

# Wrangling of dataframe into the right form to store in SQL
df_stg <- df_staging %>%
  distinct(local_government_area) %>%
  arrange(local_government_area)
df_stg <- as.data.frame(gsub(c("[*]"), "", df_stg$local_government_area))
colnames(df_stg) <- 'local_government_area'

df_load <- df_stg %>%
  left_join(curr_dim, by='local_government_area') %>%
  filter(is.na(dim_local_government_area_key)==TRUE)
df_load <- df_load %>%
  select(local_government_area)
# colnames(df_load) <- sub(".x", "", colnames(df_load))

# Save Records into DIM table
dbExecute(db_connection,"start transaction;")
dbWriteTable(db_connection,"dim_local_government_area",df_load, append=TRUE, row.names=FALSE)
dbExecute(db_connection,"commit;")
