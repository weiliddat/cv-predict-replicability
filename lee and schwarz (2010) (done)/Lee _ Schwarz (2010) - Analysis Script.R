require(effsize)
require(stats)
require(doBy)
options(digits=10)
setwd("~/Dropbox/uva/Nosek lab/reproducibility help/2016/lee/data") #Arianne comment: remove?


#the data file includes the dvs that were manually calculated based on the before and after 
#rankings.  
data <- read.csv ("DVs-2-demographics-added.csv", header=TRUE) #Arianne comment: we yield the correct results if replaced by "Lee & Schwarz (2010) - Replication Data.csv" file.
#Excluding observations for round 1
round1 <- subset(data, DataCollection == 1 & Exc == 0)
#Excluding observations for full data
full<-subset(data, Exc == 0)

#Round 1
#BeforeDV and AfterDV are both calculdated as (Rank of Chosen - Rank of Rejected)
#The difference variable is BeforeDV - AfterDV
t.test(round1$BeforeDV, round1$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
cohen.d(round1$BeforeDV, round1$AfterDV, paired=TRUE)

anova(lm(difference ~ ConditionFactor, data=round1))
summaryBy(difference ~ ConditionFactor,data=round1, FUN=c(mean,sd))

#Pooled
t.test(full$BeforeDV, full$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
describe(full$BeforeDV)
describe(full$AfterDV)
cohen.d(full$BeforeDV, full$AfterDV)
describe(full)

anova(lm(difference ~ ConditionFactor, data=full))
summaryBy(difference ~ ConditionFactor,data=full, FUN=c(mean,sd))

### CV
library(readr)
library(caret)
library(dplyr)

data <- read_csv("Lee & Schwarz (2010) - Replication Data.csv") %>% 
  filter(Exc == 0)

lm(difference ~ ConditionFactor, data = data) %>% summary()

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(difference ~ ConditionFactor, data = data, trControl = cvControl, method = "lm", na.action = na.omit)

fit1

summary(fit1)
