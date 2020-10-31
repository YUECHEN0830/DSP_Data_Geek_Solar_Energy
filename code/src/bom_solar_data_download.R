library(rvest)
library(here)

bom_solar_data_download <- function(data_type=203, station_num, p_display_type, dest_folder_path="data/raw_datasets") {
  html_url <- "http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_startYear=&p_c=&" %>%
    paste0("p_display_type=", p_display_type, "&") %>%
    paste0("p_nccObsCode=", data_type, "&") %>%
    paste0("p_stn_num=", station_num)
  web <- read_html(html_url)
  
  # get <a> download link
  file_link <- web %>%
    html_nodes("div#content-block ul.downloads li a") %>%
    html_attr("href")
  file_url <- paste0("http://www.bom.gov.au", file_link[1])
  
  # get product code
  product_code_line <- web %>%
    html_nodes("p#prodCodeDisplay") %>%
    html_text() %>%
    strsplit(split = " ")
  product_code <- product_code_line[[1]][3]
  
  # get file path
  file_path <- here::here(dest_folder_path, paste0(paste(product_code, station_num, "2020", sep = "_"), ".zip"))
  
  # download
  download.file(url = file_url, destfile = file_path, method = "curl")
  
  # decompress zip file
  unzip(file_path, exdir=here::here(dest_folder_path))
  file.remove(file_path)
}

print_test <- function(a){print(a)}