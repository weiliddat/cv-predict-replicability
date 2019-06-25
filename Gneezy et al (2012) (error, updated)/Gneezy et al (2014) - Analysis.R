# --------------------
# SOCIAL SCIENCES REPLICATION PROJECT
# 
# Replication Study  : Gneezy et al. (2014) Science
# Replication Authors: Colin Camerer, Taisuke Imai, Dylan Manfredi, Gideon Nave
# 
# Last update: February 2, 2017
# --------------------


library(data.table)
library(mfx)

rm(list = ls())
graphics.off()

# Set the location of the code and data files as the working directory
setwd("set your working directory here")


# -----
# REPLICATION RESULTS 
# -----

# Load data
data <- read.csv(file = "Gneezy et al (2014) - Data.csv", na.strings = c("NA", ""))
# Variables
#  - subjectID_all : Subject ID
#  - subjectID_cond: Subject ID within each condition
#  - condition     : 0=50% overhead; 1=50% overhead, covered
#  - charityChoice : 0=Kids Korps; 1=charity: water
#  - freqDonation  : "How often do you donate money to non-profits?" (1-low; 6-high)
#  - familiar_Water: "How familiar are you with charity: water?" (1-low; 7-high)
#  - male          : Male dummy
#  - female        : Female dummy

# Descriptive statistics
dt <- data.table(data)
print("Summary statistics: All")
dt[, list(num.subj            = .N,
          num.male            = sum(male),
          frac.male           = mean(male),
          avg.age             = mean(age),
          sd.age              = sd(age),
          frac.choice.charity = mean(charityChoice))]

print("Summary statistics: Treatment")
dt[, list(num.subj            = .N,
          num.male            = sum(male),
          frac.male           = mean(male),
          avg.age             = mean(age),
          sd.age              = sd(age),
          frac.choice.charity = mean(charityChoice)), 
   by = condition]

# Two-sample z-test of proportion
z.prop = function(x1, x2, n1, n2) {
  numerator    <- (x1/n1) - (x2/n2)
  p.common     <- (x1+x2) / (n1+n2)
  denominator  <- sqrt(p.common * (1-p.common) * (1/n1 + 1/n2))
  z.prop.stat  <- numerator / denominator
  return(z.prop.stat)
}

z <- z.prop(sum(data[data$condition==1, "charityChoice"]), 
            sum(data[data$condition==0, "charityChoice"]), 
            nrow(data[data$condition==1,]), 
            nrow(data[data$condition==0,]))

# Test results
print(paste0("z-statistic = ", formatC(z, digits = 6)))
print(paste0("p = ", formatC(2*pnorm(-abs(z)))))


# -----
# ADDITIONAL ANALYSIS 
# -----

# Probit regressions
probitmfx(formula = charityChoice ~ condition, data = data)
probitmfx(formula = charityChoice ~ condition + female, data = data)
probitmfx(formula = charityChoice ~ condition + female + age, data = data)
probitmfx(formula = charityChoice ~ condition + female + age + familiar_Water + freqDonation, data = data)

# CV
library(caret)
library(MASS)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(as.factor(charityChoice) ~ as.factor(condition), data = data, trControl = cvControl, method = "polr", na.action = na.omit)

print(fit1)
summary(fit1)
