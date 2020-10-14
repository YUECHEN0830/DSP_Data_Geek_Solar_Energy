# if(!file.exists(./data)) {dir.create("./data")}

# url
file_url <- "http://www.bom.gov.au/tmp/cdio/IDCJAC0016_023034_2020.zip"
# download
download.file(file_url, destfile = "./data/raw_datasets/IDCJAC0016_023034_2020.zip", method = "curl")

# uncompress zip file
unzip(here::here("data/raw_datasets", "IDCJAC0016_023034_2020.zip"), exdir=here::here("data/raw_datasets"))

# read csv
dd <- read.csv(here::here("data/raw_datasets", "IDCJAC0016_023034_2020_Data.csv"))

file.remove(here::here("data/raw_datasets", "IDCJAC0016_023034_2020.zip"))


# http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=023034&p_c=-106273620&p_nccObsCode=193&p_startYear=2020
