library(here)
source(here("code/src", "bom_solar_data_download.R"))

print_test(2)

bom_solar_data_download(station_num=023115)