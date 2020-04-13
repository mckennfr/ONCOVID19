options(stringsAsFactors = FALSE)

# confirmed cases

# url <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv"
url <- "https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv"
ont_data <- read.csv(url)

ont_data <- ont_data[,c("Reported.Date", "Total.Cases", "Deaths", "Resolved")]
names(ont_data) <- c("date", "confirmed_cum", "death_cum", "resolved_cum")
ont_data[is.na(ont_data)] <- 0
ont_data$date <- as.Date(ont_data$date)

ont_data$active_cum <- ont_data$confirmed_cum - ont_data$death_cum

ont_data$confirmed <- ont_data$confirmed_cum - c(0, ont_data$confirmed_cum[-nrow(ont_data)])
ont_data$death <- ont_data$death_cum - c(0, ont_data$death_cum[-nrow(ont_data)])
ont_data$active <- ont_data$active_cum - c(0, ont_data$active_cum[-nrow(ont_data)])
ont_data$recovered <- ont_data$resolved_cum - c(0, ont_data$resolved_cum[-nrow(ont_data)])

library(coronavirus)
data(coronavirus)
#update_datasets(silence = FALSE)

cond <- coronavirus$Province.State == "Ontario"
corona2 <- coronavirus[!cond,]

mn_dt <- as.Date(min(c(corona2$date, ont_data$date)))
mx_dt <- as.Date(max(c(corona2$date, ont_data$date)))

# confirmed first
tmp <- data.frame(Province.State = "Ontario",
            Country.Region = "Canada",
            Lat = 51.2538,
            Long = -85.3232,
            date = seq(mn_dt, mx_dt, 1L),
            cases = 0L,
            type = "confirmed")

tmp$cases <- ifelse(tmp$date %in% ont_data$date, 
                    ont_data$confirmed[match(tmp$date, ont_data$date)],
                    0L)

corona2 <- rbind(corona2, tmp)

# death next
tmp <- data.frame(Province.State = "Ontario",
                  Country.Region = "Canada",
                  Lat = 51.2538,
                  Long = -85.3232,
                  date = seq(mn_dt, mx_dt, 1L),
                  cases = 0L,
                  type = "death")

tmp$cases <- ifelse(tmp$date %in% ont_data$date, 
                    ont_data$death[match(tmp$date, ont_data$date)],
                    0L)

corona2 <- rbind(corona2, tmp)

# recovered next
tmp <- data.frame(Province.State = "Ontario",
                  Country.Region = "Canada",
                  Lat = 51.2538,
                  Long = -85.3232,
                  date = seq(mn_dt, mx_dt, 1L),
                  cases = 0L,
                  type = "recovered")

tmp$cases <- ifelse(tmp$date %in% ont_data$date, 
                    ont_data$recovered[match(tmp$date, ont_data$date)],
                    0L)

corona2 <- rbind(corona2, tmp)


cond <- corona2$Province.State == "Ontario" & corona2$type == "confirmed"
df <- corona2[cond, c("date", "cases")]
df$cuml <- cumsum(df$cases)
df <- df[df$cuml > 0,c("date","cuml")]
df <- df[!duplicated(df$cuml),]
df$X <- as.numeric(df$date - min(df$date))
df$Y <- as.numeric(df$cuml)

mod1 <- nls(log(Y) ~ Const + r * X + I(log(K - Y)), 
            data = df[-(1:8),], 
            start = c(Const = 1, r = 0.25, K = 10000))
print(summary(mod1))

pars <- mod1$m$getAllPars()

a <- pars['K'] * exp(pars['Const'])
r <- pars['r']
b <- exp(pars['Const'])

df$Y2 <- a * exp(r * df$X) / (1 + b * exp(r * df$X))

addnl <- 1:30
tmp <- data.frame(date = as.Date(max(df$date)) + addnl,
                  cuml = NA_integer_,
                  X = max(df$X) + addnl,
                  Y = NA_real_)
tmp$Y2 <- a * exp(r * tmp$X) / (1 + b * exp(r * tmp$X))

df <- rbind(df, tmp)

