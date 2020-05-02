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
macrs_39 <- function(m = 1) {
  ann <- floor(100000 / 39) / 100000 
  fst <- round((12.5 - m) / 12 * ( 1 - 38 * ann), 5)
  lst <- 1 - 38 * ann - fst
  c(fst, rep(ann, 38), lst)
}

macrs_y <- function(m = 1L, y = 39L) {
  ann <- floor(100000 / (y - 1L)) / 100000 
  fst <- round((12.5 - m) / 12 * ( 1 - (y - 1L) * ann), 5)
  lst <- 1 - (y - 1L) * ann - fst
  c(fst, rep(ann, (y - 1L)), lst)  
}


r <- 0.05
#AII_adj <- (1 + 1.5 * r) / (1 + 0.5 * r)

flag = 1
AII_adj <- 1 + flag * r / (1 + 0.5 * r)
PV_on <- 0.06 / (0.06 + r) * AII_adj


f_us <- function(L) r * PV_on * L + exp(-r * L) - 1
soln <- uniroot(f_us, c(2,40))




mn_dif <- 999
mn_y <- -1L
for(y in 2:39) {
  PV_us <- sum((1 + r) ^ -(1:(y+1L)) * macrs_y(6L, y))
  dif <- abs(PV_us - PV_on)
  cat(y, PV_us, dif, "\n")
  if (dif < mn_dif) {
    mn_dif <- dif
    mn_y <- y
  }
}

PV_ct <- function(L = 39, r = 0.05, t0 = 0.5, t1 = 0.5) {
  (1 - exp(-r * L)) * exp(-r * (t1 - t0)) / r / L
}

PV_us <- sum((1 + r) ^ -(1:40) * macrs_39(6))

alpha_0 <- r * PV_us / (1 - PV_us)


alpha_us <- PV_us * r / (AII_adj - PV_us)



