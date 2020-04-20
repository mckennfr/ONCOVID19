library(geojsonsf)
library(sf)
library(ggplot2)

options(stringsAsFactors = FALSE)

# confirmed cases

# url <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv"
url <- "https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv"
ont_data <- read.csv(url)

ont_cor <- ont_data[,c("Reported.Date", "Total.Cases", "Deaths")]
names(ont_cor) <- c("date", "confirmed_cum", "death_cum")
ont_cor[is.na(ont_cor)] <- 0

ont_cor$active_cum <- ont_cor$confirmed_cum - ont_cor$death_cum

ont_cor$confirmed <- ont_cor$confirmed_cum - c(0, ont_cor$confirmed_cum[-nrow(ont_cor)])
ont_cor$death <- ont_cor$death_cum - c(0, ont_cor$death_cum[-nrow(ont_cor)])
ont_cor$active <- ont_cor$active_cum - c(0, ont_cor$active_cum[-nrow(ont_cor)])


dat_conf <- ont_data

df <- data.frame(Row.Id = 1:nrow(dat_conf),
                 X = dat_conf$Reported.Date,
                 Y = dat_conf$Total.Cases,
                 Y2 = dat_conf$Deaths)

cond <- is.na(df$Y) | duplicated(df$Y)
df1 <- df[!cond,]
df1$X1 <- c(0, diff(as.Date(df1$X),1))
df1$X2 <- cumsum(df1$X1)

df2 <- df1[,c("Y", "X2")]
names(df2) <- c("Y", "X")
df2$Xm1 <- c(NA, df2$X[1:(nrow(df2)-1)])
df2$Ym1 <- c(NA, df2$Y[1:(nrow(df2)-1)])
df2$dY <- df2$Y - df2$Ym1
df2$dX <- df2$X * df2$Xm1
df2$X1 <- df2$dX * df2$Y
df2$X2 <- -(df2$dX * df2$Y * df2$Y)

mod1 <- lm(dY ~ X1 + X2 - 1, data = df2[-(1:8),])

print(summary(mod1))

Kest <- mod1$coefficients[1] / mod1$coefficients[2]


mod2 <- lm(I(log(Y)) ~ X, data=df2[-(1:8),])

print(summary(mod2))

mod3 <- nls(log(Y) ~ Const + r * X + I(log(K - Y)), 
            data = df2[-(1:8),], 
            start = c(Const = 1, r = 0.25, K = 1.2*max(df2$Y)+0.1))
print(summary(mod3))

pars <- mod3$m$getAllPars()

a <- pars['K'] * exp(pars['Const'])
r <- pars['r']
b <- exp(pars['Const'])

xc <- 0:120
yc <- a * exp(r * xc) / (1 + b * exp(r * xc))

yc1 <- exp(mod2$coefficients[1]) * exp(mod2$coefficients[2] * xc)


# yc <- vector(mode = "numeric", length(xc))
# yc[1] <- df2$Y[which(df2$X == min(xc))]
# c1 <- 1+ mod1$coefficients[1]
# c2 <- mod1$coefficients[2]
# for(i in 2:length(xc)) {
#   yc[i] <- c1 * yc[i - 1] + c2 * yc[i - 1] * yc[i - 1]
# }

plot(df2$X, df2$Y, type = "b", lwd=3, 
     ylim = c(0,0.95*pars['K']), xlim = c(0, 90),
     ylab = "Number of Cases",
     xlab = "Days since beginnning of outbreak",
     main = "COVID-19 Cases in Ontario")
lines(xc, yc1, lwd=2, col="red")
lines(xc, yc, lwd = 2, col= "red", lty=3)






if (is.null(dat_conf$ROW_ID)) dat_conf$ROW_ID <- 1:nrow(dat_conf)
    
# url <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/4f39b02b-47fe-4e66-95b6-e6da879c6910/download/conposcovidloc.geojson"
# geo_conf <- geojson_sf(url)

# totals

#tmp <- aggregate(ROW_ID ~ RESOLVED + ACCURATE_EPISODE_DATE, data = dat_conf, FUN = length)
tmp <- aggregate(ROW_ID ~ Resolved + Reported.Date, data = dat_conf, FUN = length)
library(reshape2)
tbl <- dcast(tmp, Reported.Date ~ Resolved, value.var = "ROW_ID")

tbl$cum_Deaths <- cumsum(ifelse(is.na(tbl$Deaths), 0, tbl$Deaths))
tbl$cum_Total.Cases <- cumsum(tbl$Yes)
tbl$cum_No <- cumsum(tbl$No)

lhin <- st_read("C:/STC_Data/LHIN/LHIN_Sub_Regions_Cartographic_AUGUST_2017.gdb")

plot(lhin$Shape)

library(coronavirus)
data(coronavirus)
update_datasets()
corona2 <- coronavirus[coronavirus$Province.State == "Ontario",]
