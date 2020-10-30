library(here)
source(here("code/src", "bom_solar_data_download.R"))

print_test(2)

bom_solar_data_download(station_num = 023115)
bom_solar_data_download(data_type = 36, station_num = 3003, dest_folder_path = "data/raw_datasets/BOM_temp")

