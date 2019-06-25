# --------------------
# SOCIAL SCIENCES REPLICATION PROJECT
# 
# Replication Study  : Wilson et al. (2014) Science
# Replication Authors: Colin Camerer, Taisuke Imai, Dylan Manfredi, Gideon Nave
# 
# Last update: February 19, 2017
# --------------------


library(dplyr)
library(data.table)
library(Rmisc)

rm(list = ls())
graphics.off()

# Set the location of the code and data files as the working directory
setwd("set your working directory here")


# -----
# REPLICATION RESULTS
# -----

# Load data
data <- read.csv(file = "Wilson et al (2014) - Data.csv", na.strings = c("NA", ""))
# Variables
#  - condition           : "External activities" or "Standard thought instruction" 
#  - subjectID           : Subject ID within each condition
#  - scale_enjoyable     : “How enjoyable was this part of the study?”
#  - scale_entertain     : “How entertaining was this part of the study?”
#  - scale_boring        :  “How boring was this part of the study?”
#  - scale_boring_reverse: 10 - scale_boring
#  - gender              : Male or Female
#  - male                : 1=male; 0=female
#  - age                 : Age
#  - psych.major         : Psychology major or Non-psychology major

# Self rated enjoyment scale
data$s.r.enjoyment <- (data$scale_enjoyable + data$scale_entertain + data$scale_boring_reverse) / 3
stats              <- ddply(data, .(condition), summarise, mean = mean(s.r.enjoyment), sd = sd(s.r.enjoyment))

# Descriptive statistics
dt <- data.table(data)
print("Summary statistics: All")
dt[, list(num.subj      = .N,
          num.male      = sum(male),
          frac.male     = mean(male),
          avg.age       = mean(age),
          sd.age        = sd(age))]

print("Summary statistics: Treatment")
dt[, list(num.subj      = .N,
          num.male      = sum(male),
          frac.male     = mean(male),
          avg.age       = mean(age),
          sd.age        = sd(age),
          avg.enjoyment = mean(s.r.enjoyment),
          sd.enjoyment  = sd(s.r.enjoyment)), 
   by = condition]

# Main test: Independent sample t-test
summarySE(data, measurevar = c("s.r.enjoyment"), groupvars = c("condition"))
test.result     <- t.test(data$s.r.enjoyment~data$condition, mu = 0, alt = "two.sided", conf.level = 0.95, var.eq = TRUE, paired = FALSE)
check.equal.var <- var.test(data$s.r.enjoyment~data$condition) # Test equality of variance
print(paste0("Independent sample t-test: t(", test.result$parameter, ") = ", formatC(test.result$statistic, digits = 6),
             ", p = ", formatC(test.result$p.value, digits = 6)))

# Robustness check: Psychology major only
summarySE(data[data$psych.major=="Psych",], measurevar = c("s.r.enjoyment"), groupvars = c("condition"))
test.result.psych <- t.test(data[data$psych.major=="Psych", c("s.r.enjoyment")]~data[data$psych.major=="Psych", c("condition")], mu = 0, alt = "two.sided", conf.level = 0.95, var.eq = TRUE, paired = FALSE)
print(paste0("Independent sample t-test (psych only): t(", test.result.psych$parameter, ") = ", formatC(test.result.psych$statistic, digits = 6),
             ", p = ", formatC(test.result.psych$p.value, digits = 6)))


library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(, data = data, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)