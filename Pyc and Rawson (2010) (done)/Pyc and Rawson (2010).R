# --------------------
# SOCIAL SCIENCES REPLICATION PROJECT
# 
# Replication Study  : Pyc and Rawson (2010) Science
# Replication Authors: Colin Camerer, Taisuke Imai, Dylan Manfredi, Gideon Nave
# 
# Last update: October 16, 2017
# --------------------


library(dplyr)
library(data.table)
library(reshape2)
library(Rmisc)

rm(list = ls())
graphics.off()

# Set the location of the code and data files as the working directory
setwd("set your working directory here")


# -----
# REPLICATION ANALYSIS 
# -----

# Load data
data <- read.csv(file = "Pyc and Rawson (2010) - Data.csv", header = TRUE, na.strings = c("NA", ""), stringsAsFactors = FALSE)
# Variables
# - round      : Data collection round
# - Treatment  : Treatment name
# - condition  : Experimental conbdition (7 or 8)
# - subject.id : Subject ID (within each condition)
# - pair.num   : Word-pair ID
# - key.2      : Keyword mediator recorded in session 2
# - key.1.x    : Keyword mediators (x=1, 2, 3, 4) recorded in session 1
# - levenshtein: Levenshtein's distance between strings
# - nonresponse: =1 if subject could not recall keyword

num.subj <- c(length(unique(data[data$treatment=="Test-restudy", "subject.id"])),
              length(unique(data[data$treatment=="Restudy", "subject.id"])))

# Variable of interest: Fraction of mediators correctly recalled at the final test
recall.item   <- data.frame()
frac.recalled <- data.frame()
for (con in 1:2) {
  for (s in 1:num.subj[con]) {
    # Subject-level data
    sub.data <- data[data$condition==6+con & data$subject.id==s,]

    recalled <- matrix(0, 48, 1)
    for (i in 1:48) {
      # Exclude "I don't remember"
      if (sub.data[i, c("nonresponse")] == 0) {
        recalled[i, 1] <- is.element(sub.data[i, which(colnames(sub.data) %in% c("key.2"))], 
                                     sub.data[i, which(colnames(sub.data) %in% c("key.1.1", "key.1.2", "key.1.3", "key.1.4"))]) + 0
      }
    }
    
    recall.item   <- rbind(recall.item, recalled)
    frac.recalled <- rbind(frac.recalled, 
                           data.frame(round      = sub.data[1, c("round")],
                                      treatment  = sub.data[1, c("treatment")],
                                      subject.id = s,
                                      frac       = mean(recalled)))
  }
}


# ----- First Round Data Collection ----- #
print("---First Round ---")
dt <- data.table(frac.recalled[frac.recalled$round==1,])
dt[, list(num.subj   = .N,
          avg.recall = mean(frac),
          sd.recall  = sd(frac)),
   by = treatment]

test.result <- t.test(frac.recalled[frac.recalled$round==1, c("frac")]~frac.recalled[frac.recalled$round==1, c("treatment")], 
                      mu = 0, alt = "two.sided", conf.level = 0.95, var.eq = TRUE, paired = FALSE)
print(paste0("Independent sample t-test: t(", test.result$parameter, ") = ", formatC(test.result$statistic, digits = 6),
             ", p = ", formatC(test.result$p.value, digits = 6)))


# ----- First and Second Round Data Collection Pooled ----- #
print("---First and Second Round Pooled ---")
dt <- data.table(frac.recalled)
dt[, list(num.subj   = .N,
          avg.recall = mean(frac),
          sd.recall  = sd(frac)),
   by = treatment]

test.result <- t.test(frac.recalled$frac~frac.recalled$treatment, 
                      mu = 0, alt = "two.sided", conf.level = 0.95, var.eq = TRUE, paired = FALSE)
print(paste0("Independent sample t-test: t(", test.result$parameter, ") = ", formatC(test.result$statistic, digits = 6),
             ", p = ", formatC(test.result$p.value, digits = 6)))



### CV
library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(frac ~ treatment, data = frac.recalled, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)





