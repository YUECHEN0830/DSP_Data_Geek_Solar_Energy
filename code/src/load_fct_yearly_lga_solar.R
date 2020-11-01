library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
root_config <- read.csv(here("code/config", "db_connection_config.csv")) %>% filter(user_key == "rato_rds")
db_connection <- db_connect(root_config)

sql_staging <- "select distinct 
  replace(local_government_area,'*','') as local_government_area
  ,daily_average
  ,general_supply
  ,off_peak_hot_water
  ,total_MWh
  ,off_peak_customers
  ,ttotal_customers
  ,res_sol_customers
  ,non_res_sol_customers
  ,res_sol_capacity_kWp
  ,non_res_sol_capacity_kWp
  ,`sol_energy_exported_to_ grid_MWh`
  ,`non_res_small-medium_sites_MWh`
  ,`non_res_small-medium_sites_customers`
  ,non_res_large_sites_MWh
  ,non_res_large_sites_customers
  ,unmetered_total_MWh
	,2018 as `year`
from dsp_test.stg_ausgrid_average_201718
where 1=1
and local_government_area is not null
UNION 
select distinct 
  replace(local_government_area,'*','') as local_government_area
  ,daily_average
  ,general_supply
  ,off_peak_hot_water
  ,total_MWh
  ,off_peak_customers
  ,ttotal_customers
  ,res_sol_customers
  ,non_res_sol_customers
  ,res_sol_capacity_kWp
  ,non_res_sol_capacity_kWp
  ,`sol_energy_exported_to_ grid_MWh`
  ,`non_res_small-medium_sites_MWh`
  ,`non_res_small-medium_sites_customers`
  ,non_res_large_sites_MWh
  ,non_res_large_sites_customers
  ,unmetered_total_MWh
	,2019 as `year`
from dsp_test.stg_ausgrid_average_201819
where 1=1
and local_government_area is not null
;
"

## Get staging records
df_staging <- db_query(db_connection, query_sql = sql_staging)

# ----------------------------------------------------------------------
# insert data to fact table
dim_lga <- db_query(db_connection, query_sql = "select * from dim_local_government_area;")

df_write <- dim_lga %>%
  right_join(df_staging, by = "local_government_area") %>%
  select(-c("local_government_area","dim_created_date","dim_updated_date")) %>%
  arrange(dim_local_government_area_key)

# insert data
db_write(db_connection, table_name = "fct_yearly_lga_solar", dataset = df_write)
db_disconnect(db_connection)


