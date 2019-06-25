library(psych)
library(ez)
library(reshape2)
library(dplyr)
library(car)
library(compute.es)
library(MBESS)

#THIS FIRST CHUNK IS JUST FOR REFERENCE ABOUT VARIABLE CREATION - TO RUN ANY REPLICATION ANALYSES, 
#START WITH THE CLEANED DATA, IN THE CHUNK BELOW

#Read in the data
rb<-read.csv("Ramirez__Beilock_Replication.csv", header=FALSE, skip=2)
rb.names<-read.csv("Ramirez__Beilock_Replication.csv")
names(rb)<-names(rb.names)
rm(rb.names)

#Read in the contextual data
rb.context<-read.csv("SSRP Data Collection - Ramirez & Beilock.csv")
rb.context$ID<-as.numeric(substr(rb.context$ID, 3,5))

#Merge the two together
rb<-merge(rb, rb.context, by="ID", all.x=TRUE)
rm(rb.context)

rb$Condition<-factor(rb$Condition, levels=1:2, labels=c("Control", "Expressive"))
rb$Pressure<-factor(rb$Pressure, levels=1:2, labels=c("Low", "High"))

#Rename the scoring variables
names(rb)[names(rb)=="SC0_0"]<-"Practice"
names(rb)[names(rb)=="SC1_0"]<-"Pretest.All"
names(rb)[names(rb)=="SC2_0"]<-"Pretest.High"
names(rb)[names(rb)=="SC3_0"]<-"Pretest.Low"
names(rb)[names(rb)=="SC4_0"]<-"Posttest.All"
names(rb)[names(rb)=="SC5_0"]<-"Posttest.High"
names(rb)[names(rb)=="SC6_0"]<-"Posttest.Low"
names(rb)[names(rb)=="SC7_0"]<-"STAI"
names(rb)[names(rb)=="SC8_0"]<-"Expressivity"

#Create the change in scores from pre- to post- (for the Expressivity secondary analysis)
rb$PrePostChange<-rb$Posttest.High-rb$Pretest.Low

#Exclude anyone who scored less than chance on the pretest (that's less than 20/40)
rb$Exc.Pretest<-ifelse(rb$Pretest.All<20, 1, 0)
rb$Exclude<-ifelse(rb$Exc.==1 | rb$Exc.Pretest == 1, 1, 0)

#How many exclusions?
xtabs(~Exclude+Collection, data=rb)
#How many by experimenters?
xtabs(~Exc.+Collection, data=rb)
#How many by flunking the pretest?
xtabs(~Exc.Pretest+Collection, data=rb)

#What are the condition counts after the exclusions?
xtabs(~Pressure+Condition, data=rb, subset=Exclude==0 & Collection==1)
xtabs(~Pressure+Condition, data=rb, subset=Exclude==0)

#Output the deidentified dataset
rb<-subset(rb, select=-c(netID.x,netID.y))
write.csv(rb, "Ramirez & Beilock Full Data.csv")

#START HERE FOR THE ACTUAL ANALYSIS (USING THE CLEANED, DEIDENTIFIED DATA)
rb<-read.csv("Ramirez & Beilock (2011) - Replication Data.csv")
#Drop anyone who's been excluded
rb<-subset(rb, Exclude==0)

#Recalculate the first collection, to take the first 13 of every condition
rb$Collection<-2

for(i in 1:13){
  rb[rb$Pressure=="High" & rb$Condition=="Expressive",][i,]$Collection<-1
  rb[rb$Pressure=="Low" & rb$Condition=="Expressive",][i,]$Collection<-1
  rb[rb$Pressure=="High" & rb$Condition=="Control",][i,]$Collection<-1
  rb[rb$Pressure=="Low" & rb$Condition=="Control",][i,]$Collection<-1
}


###FIRST COLLECTION

#Get the descriptives for the samples
describe(rb[rb$Collection==1,]$Age)
table(rb[rb$Collection==1,]$Gender)

#Get the alphas for the STAI and the Expressivity scales
#First collection
with(rb[rb$Collection==1,], alpha(cbind(STAI_1, STAI_2, STAI_3, STAI_4, STAI_5, STAI_6, STAI_7, STAI_8, STAI_9, STAI_10,
                                        STAI_11, STAI_12, STAI_13, STAI_14, STAI_15, STAI_16, STAI_17, STAI_18, STAI_19, STAI_20),
                                  check.keys=T))

with(rb[rb$Collection==1,], alpha(cbind(EXP1, EXP2, EXP3), check.keys=T))

#Run the analysis!

#First, the manipulation-check - are people more anxious in the High Pressure Condition, all else equal?
tanx<-t.test(STAI~Pressure, data=rb, subset=Collection==1)
tanx
anxn<-xtabs(~Pressure, data=rb, subset=Collection==1)
tes(tanx$statistic, anxn[1], anxn[2])
with(rb[rb$Collection==1,], describeBy(STAI, Pressure))

#Is there an anxiety interaction b/n Pressure & Writing Condition? [not in the original paper, but might as
#well look, I guess]
mod.anx<-lm(STAI~Pressure*Condition, data=rb, subset=Collection==1)
Anova(mod.anx)
aggregate(STAI~Pressure+Condition, data=rb, subset=Collection==1, FUN=function(x) c("Mean"=mean(x), "SD"=sd(x)))

#Reshape the data so that scores are all in the same column (along with all the other stuff we might actually want)
rb.l<-select(rb, Pretest.High, Posttest.High, Condition, Pressure, STAI, Expressivity, Age, Gender, Collection)
rb.l$id<-1:nrow(rb)
rb.l<-melt(rb.l, measure.vars=c("Pretest.High", "Posttest.High"), variable.name="Test",value.name="Score")

#Run the primary analysis
mod1<-ezANOVA(data=rb.l[rb.l$Collection==1 &rb.l$Pressure=="High",], dv=Score, wid=id, within=Test, between=Condition)
print(mod1)

#Focal Follow-up Tests (all exclusively on the High-Pressure Condition)

#Comparing the Posttest difference b/n Control & Expressive
cetest<-t.test(Posttest.High~Condition, data=rb, subset=Pressure=="High" & Collection==1)
cetest
cen<-xtabs(~Condition, data=rb, subset=Pressure=="High" & Collection==1)
tes(cetest$statistic, cen[1], cen[2])
with(rb[rb$Collection==1 & rb$Pressure=="High",], describeBy(Posttest.High, Condition))

#Comparing the difference from pretest to posttest in the Control condition
ppctest<-with(rb[rb$Pressure=="High" & rb$Condition=="Control" & rb$Collection==1,], 
     t.test(Pretest.High, Posttest.High, paired=TRUE))
ppctest
with(rb[rb$Pressure=="High" & rb$Condition=="Control" & rb$Collection==1,], describe(Pretest.High))
with(rb[rb$Pressure=="High" & rb$Condition=="Control" & rb$Collection==1,], describe(Posttest.High))
#Use a d_z instead of the normal d for an effect size (since w/in-subjects)
ci.sm(ncp=ppctest$statistic, N=cen[1])

#Comparing the difference from pretest to posttest in the Expressive Writing condition
ppetest<-with(rb[rb$Pressure=="High" & rb$Condition=="Expressive" & rb$Collection==1,], 
     t.test(Pretest.High, Posttest.High, paired=TRUE))
ppetest
with(rb[rb$Pressure=="High" & rb$Condition=="Expressive" & rb$Collection==1,], describe(Pretest.High))
with(rb[rb$Pressure=="High" & rb$Condition=="Expressive" & rb$Collection==1,], describe(Posttest.High))
#Get the d_z
ci.sm(ncp=ppetest$statistic, N=cen[2])

#Secondary analysis 
#Do expressivity scores correlate w/improvement from pre- to post-test in the Expressive, High-Pressure condition?
cor.test(~Expressivity+PrePostChange, data=rb, subset=Condition=="Expressive" & Pressure=="High" & Collection==1)


#FULL DATA!

#Descriptives
describe(rb$Age)
table(rb$Gender)

xtabs(~Pressure, data=rb)

#Get the alphas for the STAI and the Expressivity scales

with(rb, alpha(cbind(STAI_1, STAI_2, STAI_3, STAI_4, STAI_5, STAI_6, STAI_7, STAI_8, STAI_9, STAI_10,
                                        STAI_11, STAI_12, STAI_13, STAI_14, STAI_15, STAI_16, STAI_17, STAI_18, STAI_19, STAI_20),
                                  check.keys=T))

with(rb, alpha(cbind(EXP1, EXP2, EXP3), check.keys=T))


#Run the analysis!

#First, the manipulation-check - are people more anxious in the High Pressure Condition, all else equal?
tanx<-t.test(STAI~Pressure, data=rb)
tanx
anxn<-xtabs(~Pressure, data=rb)
tes(tanx$statistic, anxn[1], anxn[2])
describeBy(rb$STAI, rb$Pressure)

#Is there an anxiety interaction b/n Pressure & Writing Condition? [not in the original paper, but might as
#well look, I guess]
mod.anx<-lm(STAI~Pressure*Condition, data=rb)
Anova(mod.anx)
aggregate(STAI~Pressure+Condition, data=rb, FUN=function(x) c("Mean"=mean(x), "SD"=sd(x)))

#Reshape the data so that scores are all in the same column (along with all the other stuff we might actually want)
rb.l<-select(rb, Pretest.High, Posttest.High, Condition, Pressure, STAI, Expressivity, Age, Gender, Collection)
rb.l$id<-1:nrow(rb)
rb.l<-melt(rb.l, measure.vars=c("Pretest.High", "Posttest.High"), variable.name="Test",value.name="Score")

#Run the primary analysis
mod1<-ezANOVA(data=rb.l[rb.l$Pressure=="High",], dv=Score, wid=id, within=Test, between=Condition)
print(mod1)



### CV ###

rb.l %>%
  filter(Pressure == "High")




###

#Focal Follow-up Tests (all exclusively on the High-Pressure Condition)

#Comparing the Posttest difference b/n Control & Expressive
cetest<-t.test(Posttest.High~Condition, data=rb, subset=Pressure=="High")
cetest
cen<-xtabs(~Condition, data=rb, subset=Pressure=="High")
tes(cetest$statistic, cen[1], cen[2])
with(rb[rb$Pressure=="High",], describeBy(Posttest.High, Condition))

#Comparing the difference from pretest to posttest in the Control condition
ppctest<-with(rb[rb$Pressure=="High" & rb$Condition=="Control",], 
              t.test(Pretest.High, Posttest.High, paired=TRUE))
ppctest
with(rb[rb$Pressure=="High" & rb$Condition=="Control",], describe(Pretest.High))
with(rb[rb$Pressure=="High" & rb$Condition=="Control",], describe(Posttest.High))
#Use a d_z instead of the normal d for an effect size (since w/in-subjects)
ci.sm(ncp=ppctest$statistic, N=cen[1])

#Comparing the difference from pretest to posttest in the Expressive Writing condition
ppetest<-with(rb[rb$Pressure=="High" & rb$Condition=="Expressive",], 
              t.test(Pretest.High, Posttest.High, paired=TRUE))
ppetest
with(rb[rb$Pressure=="High" & rb$Condition=="Expressive",], describe(Pretest.High))
with(rb[rb$Pressure=="High" & rb$Condition=="Expressive",], describe(Posttest.High))
#Get the d_z
ci.sm(ncp=ppetest$statistic, N=cen[2])

#Secondary analysis 
#Do expressivity scores correlate w/improvement from pre- to post-test in the Expressive, High-Pressure condition?
cor.test(~Expressivity+PrePostChange, data=rb, subset=Condition=="Expressive" & Pressure=="High")


#JUST THE PRESPECIFIED N FOR THE HIGH-PRESSURE CONDITIONS

#Build out the dataset
rb$Collection.Limited<-NA
rb[rb$Pressure=="Low",]$Collection.Limited<-1

for(i in 1:33){
  rb[rb$Pressure=="High" & rb$Condition=="Expressive",][i,]$Collection.Limited<-1
  rb[rb$Pressure=="High" & rb$Condition=="Control",][i,]$Collection.Limited<-1
}


xtabs(~Pressure+Condition+Collection.Limited, data=rb)

#Get the descriptives for this more limited set
describe(rb[rb$Collection.Limited==1,]$Age)
table(rb[rb$Collection.Limited==1,]$Gender)

#Get the scale alphas
with(rb[rb$Collection.Limited==1,], alpha(cbind(STAI_1, STAI_2, STAI_3, STAI_4, STAI_5, STAI_6, STAI_7, STAI_8, STAI_9, STAI_10,
                                        STAI_11, STAI_12, STAI_13, STAI_14, STAI_15, STAI_16, STAI_17, STAI_18, STAI_19, STAI_20),
                                  check.keys=T))

with(rb[rb$Collection.Limited==1,], alpha(cbind(EXP1, EXP2, EXP3), check.keys=T))


#First, the manipulation-check - are people more anxious in the High Pressure Condition, all else equal?
tanx<-t.test(STAI~Pressure, data=rb, subset=Collection.Limited==1)
tanx
anxn<-xtabs(~Pressure, data=rb, subset=Collection.Limited==1)
tes(tanx$statistic, anxn[1], anxn[2])
with(rb[rb$Collection.Limited==1,], describeBy(STAI, Pressure))

#Is there an anxiety interaction b/n Pressure & Writing Condition? [not in the original paper, but might as
#well look, I guess]
mod.anx<-lm(STAI~Pressure*Condition, data=rb, subset=Collection.Limited==1)
Anova(mod.anx)
aggregate(STAI~Pressure+Condition, data=rb, subset=Collection.Limited==1, 
          FUN=function(x) c("Mean"=mean(x), "SD"=sd(x)))

#Reshape the data so that scores are all in the same column (along with all the other stuff we might actually want)
rb.l<-select(rb, Pretest.High, Posttest.High, Condition, Pressure, Collection.Limited)
rb.l$id<-1:nrow(rb)
rb.l<-melt(rb.l, measure.vars=c("Pretest.High", "Posttest.High"), variable.name="Test",value.name="Score")
rb.l<-na.omit(rb.l)

#Run the primary analysis
mod1<-ezANOVA(data=rb.l[rb.l$Collection.Limited==1 & rb.l$Pressure=="High",], dv=Score, wid=id, within=Test, between=Condition)
print(mod1)

#Focal Follow-up Tests (all exclusively on the High-Pressure Condition)

#Comparing the Posttest difference b/n Control & Expressive
cetest<-t.test(Posttest.High~Condition, data=rb, subset=Pressure=="High" & Collection.Limited==1)
cetest
cen<-xtabs(~Condition, data=rb, subset=Pressure=="High" & Collection.Limited==1)
tes(cetest$statistic, cen[1], cen[2])
with(rb[rb$Collection.Limited==1 & rb$Pressure=="High",], describeBy(Posttest.High, Condition))

#Comparing the difference from pretest to posttest in the Control condition
ppctest<-with(rb[rb$Pressure=="High" & rb$Condition=="Control" & rb$Collection.Limited==1,], 
              t.test(Pretest.High, Posttest.High, paired=TRUE))
ppctest
with(rb[rb$Pressure=="High" & rb$Condition=="Control" & rb$Collection.Limited==1,], describe(Pretest.High))
with(rb[rb$Pressure=="High" & rb$Condition=="Control" & rb$Collection.Limited==1,], describe(Posttest.High))
#Use a d_z instead of the normal d for an effect size (since w/in-subjects)
ci.sm(ncp=ppctest$statistic, N=cen[1])

#Comparing the difference from pretest to posttest in the Expressive Writing condition
ppetest<-with(rb[rb$Pressure=="High" & rb$Condition=="Expressive" & rb$Collection.Limited==1,], 
              t.test(Pretest.High, Posttest.High, paired=TRUE))
ppetest
with(rb[rb$Pressure=="High" & rb$Condition=="Expressive" & rb$Collection.Limited==1,], describe(Pretest.High))
with(rb[rb$Pressure=="High" & rb$Condition=="Expressive" & rb$Collection.Limited==1,], describe(Posttest.High))
#Get the d_z
ci.sm(ncp=ppetest$statistic, N=cen[2])

#Secondary analysis 
#Do expressivity scores correlate w/improvement from pre- to post-test in the Expressive, High-Pressure condition?
cor.test(~Expressivity+PrePostChange, data=rb, subset=Condition=="Expressive" & Pressure=="High" & 
           Collection.Limited==1)


#Checking overall math performance
#All Pretest
mean(rb$Pretest.High)/20
#Posttest in the Low-Pressure Conditions
mean(rb[rb$Pressure=="Low",]$Posttest.High)/20
