options(stringsAsFactors = FALSE)

# confirmed cases

# url <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv"
url <- "https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv"
ont_data <- read.csv(url)

ont_cor <- ont_data[,c("Reported.Date", "Total.Cases", "Deaths")]
names(ont_cor) <- c("date", "confirmed_cum", "death_cum")
ont_cor[is.na(ont_cor)] <- 0
ont_cor$date <- as.Date(ont_cor$date)

ont_cor$active_cum <- ont_cor$confirmed_cum - ont_cor$death_cum

ont_cor$confirmed <- ont_cor$confirmed_cum - c(0, ont_cor$confirmed_cum[-nrow(ont_cor)])
ont_cor$death <- ont_cor$death_cum - c(0, ont_cor$death_cum[-nrow(ont_cor)])
ont_cor$active <- ont_cor$active_cum - c(0, ont_cor$active_cum[-nrow(ont_cor)])

library(coronavirus)
data(coronavirus)
update_datasets()

cond <- coronavirus$Province.State == "Ontario"
corona2 <- coronavirus[!cond,]
tmp <- split(coronavirus[cond,], coronavirus$type[cond])

tmp2 <- tmp[[1]]
cond <- tmp2$date %in% ont_cor$date
