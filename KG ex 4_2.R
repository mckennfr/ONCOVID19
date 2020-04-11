# kaplan and glass ex. 4.2

df <- data.frame(t = seq(0.5, 2.5, 0.1),
                 x = c( 1.27,  6.58,  7.00,  8.83,  8.66,
                        5.53,  9.33, 14.57,  8.51, 17.61,
                       12.94, 18.45, 19.85, 25.03, 28.14,
                       28.31, 33.41, 41.43, 40.87, 56.71,
                       59.32))

plot(df$t,df$x, type="b",lwd=3)

mod1 <- lm(x ~ t, data = df)
print(summary(mod1))

mod2 <- lm(I(log(x)) ~ t, data = df)
print(summary(mod2))

df$x1 <- coefficients(mod1)[1] + coefficients(mod1)[2] * df$t

df$x2 <- exp(coefficients(mod2)[1]) * exp(coefficients(mod2)[2] * df$t)

lines(df$t, df$x1, lwd=3, col="red", lty=2)
lines(df$t, df$x2, lwd=3, col="red", lty=3)
