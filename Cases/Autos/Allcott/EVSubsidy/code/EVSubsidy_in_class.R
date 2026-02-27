
# clear environment and load data
rm(list = ls())
library("dplyr")
library("ggplot2")
library("fixest")

setwd("C:/Users/allcott/Documents/GitHub/EnvEconClass/homework/EVSubsidy")


# Load data frames
df = read.csv('vehicle_data.csv')



# Lifetime externality harm from driving
df$co2_cost = df$co2 * 190 / 1000
ggplot(data = subset(df,ev==0&price<50), aes(x = co2_cost)) +
  geom_histogram() + labs(x = 'Lifetime CO2 damages from driving ($000s)')


# Estimate demand in OLS
df$share <- df$quantity/250000
share0 <- 1 - sum(df$quantity)/250000

df$lnsjs0 = log(df$share / share0)
Demand = feols(df, lnsjs0 ~ price + weight + fuel_cost + hp + ev, vcov = 'hetero')

summary(Demand)
beta_p <- Demand$coefficients['price']


### Counterfactuals
# Tax
df$pT = df$price + df$co2_cost
df$VB = df$lnsjs0
df$VT = df$VB + beta_p * df$co2_cost
df$shareT = exp(df$VT) / (1+sum(exp(df$VT)))



sum(df$shareT)
sum(df$share)

# Total surplus effects
DCST <- (1/-beta_p) * ( log(1+sum(exp(df$VT))) - log(1+sum(exp(df$VB))))
DGT <- sum(df$co2_cost * df$shareT)
DET <- sum(-df$co2_cost * (df$shareT-df$share))
DTST <- DCST + DGT + DET
