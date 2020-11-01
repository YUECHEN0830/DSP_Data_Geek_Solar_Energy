df_IDC <- rbind(IDCJAC0003_12038_Data1,IDCJAC0003_14015_Data1,IDCJAC0003_15135_Data1,
      IDCJAC0003_15590_Data1,IDCJAC0003_16001_Data1,IDCJAC0003_23034_Data1,
      IDCJAC0003_26021_Data1,IDCJAC0003_3003_Data1,IDCJAC0003_31011_Data1,
      IDCJAC0003_32040_Data1,IDCJAC0003_36031_Data1,IDCJAC0003_39083_Data1,
      IDCJAC0003_48027_Data1,IDCJAC0003_5007_Data1,IDCJAC0003_72150_Data1,
      IDCJAC0003_76031_Data1,IDCJAC0003_8051_Data1,IDCJAC0003_86282_Data1,
      IDCJAC0003_91148_Data1) 

library(readr)
library(here)
library(reshape2)
library(knitr)
source(here("code/common", "mysql_connection.R"))

# get data
db_connection <- db_connect(username = 'tutorial_user', password = 'password', dbname = 'dsp_test', host = 'tutorial-db-instance.ce9zfotawf0r.us-east-2.rds.amazonaws.com')

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
db_write(db_connection, table_name = "stg_df_IDC", dataset = df_IDC)
db_disconnect(db_connection)
