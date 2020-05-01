# get official data from Johns Hopkins GitGub 


url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
global_cases <- read.csv(url)

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
global_deaths <- read.csv(url)

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
global_recov <- read.csv(url)

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
us_cases <- read.csv(url)

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
us_deaths <- read.csv(url)

library(reshape2)
corona <- melt(global_cases, id.vars = c("Province.State", "Country.Region", "Lat", "Long"))
corona$Date <- as.Date(corona$variable, "X%m.%d.%y")
corona$variable <- "confirmed"

tmp <- melt(global_deaths, id.vars = c("Province.State", "Country.Region", "Lat", "Long"))
tmp$Date <- as.Date(tmp$variable, "X%m.%d.%y")
tmp$variable <- "deaths"

corona <- rbind(corona, tmp)

tmp <- melt(global_recov, id.vars = c("Province.State", "Country.Region", "Lat", "Long"))
tmp$Date <- as.Date(tmp$variable, "X%m.%d.%y")
tmp$variable <- "recovered"

corona <- rbind(corona, tmp)






tmp <- us_cases[,-(1:6)]
tmp$Combined_Key <- NULL
nms <- sub("_", ".", names(tmp))
nms <- sub("\\.$", "", nms)
names(tmp) <- nms
tmp <- melt(tmp, id.vars = c("Province.State", "Country.Region", "Lat", "Long"))
tmp$Date <- as.Date(tmp$variable, "X%m.%d.%y")
tmp$variable <- "confirmed"
tmp <- tmp[!tmp$value == 0L,]

aggregate(value ~ Province.State + Country.Region + variable + Date, data = tmp, FUN = sum)

z <- "2.461% 2.247% 2.033% 1.819% 1.605% 1.391% 1.177% 0.963% 0.749% 0.535% 0.321% 0.107%"
z <- gsub("%", "", z)
z <- as.numeric(strsplit(z, " ")[[1]]) / 100
z2 <- (12.5 - 1:12) / 39 / 12

z2 - z
z2
