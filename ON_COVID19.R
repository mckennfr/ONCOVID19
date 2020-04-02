library(geojsonsf)
library(sf)
library(ggplot2)

options(stringsAsFactors = FALSE)

# confirmed cases

url <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv"
dat_conf <- read.csv(url)

url <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/4f39b02b-47fe-4e66-95b6-e6da879c6910/download/conposcovidloc.geojson"
geo_conf <- geojson_sf(url)


lhin <- st_read("C:/STC_Data/LHIN/LHIN_Sub_Regions_Cartographic_AUGUST_2017.gdb")

plot(lhin$Shape)
