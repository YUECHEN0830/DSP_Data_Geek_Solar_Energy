library(here)
# source(here::here("code/test", "bom_solar_data_download.R"))
source(here::here("code/common", "bom_data_download.R"))

print_test(2)

# bom_solar_data_download(station_num = 023115)

# download monthly solar data
bom_solar_data_download(data_type = 36, station_num = 3003, p_display_type = "dataFile", dest_folder_path = "data/raw_datasets/Bureau of Meteorology")

# download daily temp data
bom_solar_data_download(data_type = 122, station_num = 3003, p_display_type = "dailyDataFile", dest_folder_path = "data/raw_datasets/Bureau of Meteorology")

# download daily temp data with a new destination path
bom_solar_data_download(data_type = 122, station_num = 3003, p_display_type = "dailyDataFile", dest_folder_path = "data/raw_datasets/Bureau of Meteorology/daily_temp")