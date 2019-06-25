require(effsize)
require(stats)
require("psych")
require(doBy)
library(pwr)
options(digits=10)
setwd("~/Dropbox/uva/Nosek lab/reproducibility help/2016/lee/data")


#the data file includes the dvs that were manually calculated based on the before and after 
#rankings.  
data <- read.csv ("DVs-2-demographics-added-2017-12-06.csv", header=TRUE)
#Excluding observations for round 1
round1 <- subset(data, DataCollection == 1 & Exc == 0)
round2 <- subset(data, DataCollection == 2 & Exc == 0)
#Excluding observations for full data
full<-subset(data, Exc == 0)

#Round 1
#BeforeDV and AfterDV are both calculdated as (Rank of Chosen - Rank of Rejected)
#The difference variable is BeforeDV - AfterDV
t.test(round1$BeforeDV, round1$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
cohen.d(round1$BeforeDV, round1$AfterDV, paired=TRUE)
describe(round1$BeforeDV)
describe(round1$AfterDV)
describe(round1$age)
table(round1$gender)

anova(lm(difference ~ ConditionFactor, data=round1))
summaryBy(difference ~ ConditionFactor,data=round1, FUN=c(mean,sd))

#Pooled
describe(round2$BeforeDV)
describe(round2$AfterDV)
describe(round2$age)
table(round2$gender)

t.test(full$BeforeDV, full$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
describe(full$BeforeDV)
describe(full$AfterDV)
cohen.d(full$BeforeDV, full$AfterDV)
describe(full)
table(full$ConditionFactor)

anova(lm(difference ~ ConditionFactor, data=full))
summaryBy(difference ~ ConditionFactor,data=full, FUN=c(mean,sd))


####Exploratory Analysis based on Order####

round1AscendingOrder <- subset(data, DataCollection == 1 & Exc == 0 & ascending10otherwise==1) 
round1RandomOrder <- subset(data, DataCollection == 1 & Exc == 0 & ascending10otherwise==0) 
round2AscendingOrder <- subset(data, DataCollection == 2 & Exc == 0 & ascending10otherwise==1) 
table(full$ascending10otherwise)
fullAscendingOrder <- subset(data, Exc == 0 & ascending10otherwise==1) 
fullRandomOrder <- subset(data, Exc == 0 & ascending10otherwise==0) 

####only with those in ascending order
t.test(round1AscendingOrder$BeforeDV, round1AscendingOrder$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
cohen.d(round1AscendingOrder$BeforeDV, round1AscendingOrder$AfterDV, paired=TRUE)
describe(round1AscendingOrder$BeforeDV)
describe(round1AscendingOrder$AfterDV)
describe(round1AscendingOrder$age)
table(round1AscendingOrder$gender)

anova(lm(difference ~ ConditionFactor, data=round1AscendingOrder))
pwr.anova.test(k = 2, n = 69, f = 4.5929, sig.level = .05)
summaryBy(difference ~ ConditionFactor,data=round1AscendingOrder, FUN=c(mean,sd))

####only with those in Random order
t.test(round1RandomOrder$BeforeDV, round1RandomOrder$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
cohen.d(round1RandomOrder$BeforeDV, round1RandomOrder$AfterDV, paired=TRUE)
describe(round1RandomOrder$BeforeDV)
describe(round1RandomOrder$AfterDV)
describe(round1RandomOrder$age)
table(round1RandomOrder$gender)

anova(lm(difference ~ ConditionFactor, data=round1RandomOrder))
summaryBy(difference ~ ConditionFactor,data=round1RandomOrder, FUN=c(mean,sd))

#With Ascending Order
anova(lm(difference ~ ConditionFactor, data=fullAscendingOrder))
summaryBy(difference ~ ConditionFactor,data=fullAscendingOrder, FUN=c(mean,sd))

#With Random
anova(lm(difference ~ ConditionFactor, data=fullRandomOrder))
pwr.anova.test(k = 2, n = 121, f = 0.05003, sig.level = .05)
summaryBy(difference ~ ConditionFactor,data=fullRandomOrder, FUN=c(mean,sd))

describe(round2$BeforeDV)
describe(round2$AfterDV)
describe(round2$age)
table(round2$gender)

t.test(fullRandomOrder$BeforeDV, fullRandomOrder$AfterDV, conf.level = 0.95,  paired = TRUE, var.equal = TRUE)
describe(fullRandomOrder$BeforeDV)
describe(fullRandomOrder$AfterDV)
cohen.d(fullRandomOrder$BeforeDV, fullRandomOrder$AfterDV)
describe(fullRandomOrder)
table(fullRandomOrder$ConditionFactor)

anova(lm(difference ~ ConditionFactor, data=fullRandomOrder))
summaryBy(difference ~ ConditionFactor,data=fullRandomOrder, FUN=c(mean,sd))







