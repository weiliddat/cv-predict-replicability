library(compute.es)
library(psych)
library(cocor)

#Read in the data
kb<-read.csv("Karpicke & Blunt (2011) - Replication Data.csv")

#Remove the line with the divider
kb<-kb[-which(kb$ID=="Secondary Collection"),]

#Get the exclusions together
kb$Exclusion<-kb$Exc.1+kb$Exc.2

describe(kb$Age)
table(kb$Gender)

sum(kb$Exclusion)

#Drop anyone who's excluded
kb<-subset(kb, Exclusion==0)

#Check to see if the intercoder reliability is good enough
cor.test(kb$TS.1, kb$TS.2)
cor.test(kb$MCS.1, kb$MCS.2)
cor.test(kb$R2CS.1, kb$R2CS.2)

#Yup - it rocks, so just use the averages

#Generate a column for just the completion scores together
kb$Completion.Score<-ifelse(is.na(kb$MCS.avg)==TRUE, kb$R2CS.avg,kb$MCS.avg)

##PRIMARY TEST
kballn<-xtabs(~Condition, data=kb)
testall<-t.test(TS.avg~Condition, data=kb)
testall
tes(testall$statistic, kballn[2], kballn[3])
describeBy(kb$TS.avg, kb$Condition)

### CV

library(caret)

control <- trainControl(method = "repeatedcv", number = 10, repeats = 5)
model <- train(TS.avg ~ Condition, data = kb, trControl = control, method = "lm")
model
summary(model)

###

##SECONDARY TESTS

#Are there differences in map completion scores vs. practice tests?
t.test(Completion.Score~Condition, data=kb)
describeBy(kb$Completion.Score, kb$Condition)

#Did predicted JoLs differ by condition?
t.test(PR.2~Condition, data=kb)
describeBy(kb$PR.2, kb$Condition)

#Does a JoL predict one's actual memory?
with(kb, cor.test(PR.2, TS.avg))

#Is the prediction more accurate (i.e. tighter correlation) in one condition than another?

cocor(~PR.2+TS.avg|PR.2+TS.avg, list(kb[kb$Condition=="Concept",], kb[kb$Condition=="Retrieval",]))
