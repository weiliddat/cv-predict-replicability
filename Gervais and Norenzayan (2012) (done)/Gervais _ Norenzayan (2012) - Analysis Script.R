library(compute.es)
library(psych)

gn<-read.csv("Gervais & Norenzayan (2012) - Replication Data.csv", header=FALSE, skip=2)
gn.names<-read.csv("Gervais & Norenzayan (2012) - Replication Data.csv")
names(gn)<-names(gn.names)
rm(gn.names)

#Merge in the blind exclusion coding
exclude<-read.csv("Gervais & Norenzayan (2012) - Exclusions.csv")
exclude<-exclude[,1:2]
gn<-merge(gn, exclude, by="V1", all.x=TRUE)

#Drop anyone who didn't complete the study
gn<-subset(gn, V10==1 | is.na(Q40)==FALSE)

#Drop anyone who did not respond to the belief question
gn<-subset(gn, is.na(DV_1)==FALSE)

#Figure out how many exclusions from the first collection
ex.n<-sum(gn[1:224, "Exclude"], na.rm=TRUE)
ex.n

#Mark off the two data collections
for(i in 1:nrow(gn)){
  gn$Collection[i]<- if(i<=224+ex.n) 1
  else 2
}


#Are there differential dropout problems?
chisq.test(xtabs(~Exclude+Condition, data=gn[which(gn$Collection==1),]))
chisq.test(xtabs(~Exclude+Condition, data=gn))
xtabs(~Exclude+Condition, data=gn)

#Create a clean dataset dropping anyone IDd as excluded
gn.ex<-subset(gn, Exclude!=1)

#Gender & Age descriptives
#First Collection
table(gn[which(gn$Collection==1),]$Gender)
describe(gn[which(gn$Collection==1),]$Age)
#Pooled
table(gn$Gender)
describe(gn$Age)

#DV Descriptives for first collection
with(gn.ex[which(gn.ex$Collection==1),], describeBy(DV_1, Condition))
#DV Descriptives for just the second collection
with(gn.ex[which(gn.ex$Collection==2),], describeBy(DV_1, Condition))

#Pooled descriptives
describeBy(gn.ex$DV_1, gn.ex$Condition)


#First collection analysis
n1<-length(which(gn.ex[which(gn.ex$Collection==1),]$Condition=="Analytic"))
n2<-length(which(gn.ex[which(gn.ex$Collection==1),]$Condition=="Control"))

main.test<-t.test(DV_1~Condition, data=gn.ex, subset=Collection==1)
main.test
tes(main.test$statistic, n1, n2)

#Pooled collection analysis
n1<-length(which(gn.ex$Condition=="Analytic"))
n2<-length(which(gn.ex$Condition=="Control"))

main.test<-t.test(DV_1~Condition, data=gn.ex)
main.test
tes(main.test$statistic, n1, n2)

#Look at just the first 514 participants (as per the registration)
with(gn.ex[1:514,], describeBy(DV_1, Condition))

n1<-length(which(gn.ex[1:514,]$Condition=="Analytic"))
n2<-length(which(gn.ex[1:514,]$Condition=="Control"))

main.test<-t.test(DV_1~Condition, data=gn.ex[1:514,])
main.test
tes(main.test$statistic, n1, n2)

#Does excluding the participants make any difference?
describeBy(gn$DV_1, gn$Condition)

n1<-length(which(gn$Condition=="Analytic"))
n2<-length(which(gn$Condition=="Control"))

main.test<-t.test(DV_1~Condition, data=gn)
main.test
tes(main.test$statistic, n1, n2)

# Check which is main test
library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(DV_1 ~ Condition, data = gn, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)
