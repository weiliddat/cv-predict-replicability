clear all

insheet using "Rand et al. (2012) - Data (Part 1).tsv"
tostring study, replace 

// Original experiment analysis code used for replication of "Study 8",
// Everything that is not relevant for the study has been commented out.

////////////////////////////////
// GENERATE NECESSARY VARIABLES
// Create log-10 transformed versions of the decision time measure
* gen Ldecisiontime=log10(decisiontime)
* gen Linstructionstime=log10(timespentreadinginstructions)
// Generate contribution and prediction variables that are
// censored if they are minimum or maximal values, for use
// with the intreg function (which allows Tobit regression
// with robust standard errors)
gen cont0=contribution
replace cont0=. if contribution==0
gen cont1=contribution
replace cont1=. if contribution==40 & study~="7"
replace cont1=. if contribution==400 & study=="7"
* gen pred0=prediction
* replace pred0=. if prediction==0
* gen pred1=prediction
* replace pred1=. if prediction==40 & study~="7"
* replace pred1=. if prediction==400 & study=="7"
/////////////////////////////


* //////////////////////////
* // STUDY 1
* // contribution among faster half vs slower half
* ranksum contribution if study=="1", by(fasterhalfofdecisions)
* // regressing contribution against decision time (Tobit with robust SEs)
* xi: intreg cont0 cont1 Ldecisiontime if  study=="1" , r
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension if study=="1" , r
* //       restricting to not inlcude the sparse datapoints, 0.6<Ldecisiontime<1.2
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension if study=="1" & Ldecisiontime>.6 & Ldecisiontime<1.2, r
* //       using non-log transformed contribution times and excluding those with time > mean+3*std
* xi: intreg cont0 cont1 decisiontime age i.female usresident i.educ failedcomprehension if study=="1" & decisiontime<85, r
* ////////////////////////////


* ///////////////////////
* // STUDY 6
* // contribution in time pressure vs time delay conditions
* ranksum contribution if ((study=="6" & condition=="Time delay") | (study=="6" & condition=="Time pressure")) & disobeyedtimeconstraint==0, by(condition)
* char condition[omit] "Time delay"
* xi: intreg cont0 cont1 i.condition if ((study=="6" & condition=="Time delay") | (study=="6" & condition=="Time pressure")) & disobeyedtimeconstraint==0, r
* xi: intreg cont0 cont1 i.condition usresident age female i.educ failedcomprehension if ((study=="6" & condition=="Time delay") | (study=="6" & condition=="Time pressure")) & disobeyedtimeconstraint==0, r
* xi: intreg cont0 cont1 i.condition usresident age female i.educ failedcomprehension disobeyedtimeconstraint if ((study=="6" & condition=="Time delay") | (study=="6" & condition=="Time pressure")), r
* // comparing both study 6 conditions to the study 1 baseline
* replace condition="Baseline" if study=="1"
* ranksum contribution if ((study=="6" & condition=="Time delay" & disobeyedtimeconstraint==0) | study=="1") , by(condition)
* ranksum contribution if ((study=="6" & condition=="Time pressure" & disobeyedtimeconstraint==0) | study=="1"), by(condition)
* char condition [omit] "Baseline"
* xi: intreg cont0 cont1 i.condition if ((study=="6" & condition=="Time delay" & disobeyedtimeconstraint==0) | (study=="6" & condition=="Time pressure" & disobeyedtimeconstraint==0) | study=="1"), r
* xi: intreg cont0 cont1 i.condition usresident age female i.educ failedcomprehension if ((study=="6" & condition=="Time delay" & disobeyedtimeconstraint==0) | (study=="6" & condition=="Time pressure" & disobeyedtimeconstraint==0) | study=="1"), r
* //      generating variables to distinguish between those who disobeyed time pressure v time delay constraints
* gen disobeyedtimeconstraint_fast=disobeyedtimeconstraint
* replace disobeyedtimeconstraint_fast=0 if condition~="Time pressure"
* gen disobeyedtimeconstraint_slow=disobeyedtimeconstraint
* replace disobeyedtimeconstraint_slow=0 if condition~="Time delay"
* xi: intreg cont0 cont1 i.condition usresident age female i.educ failedcomprehension  disobeyedtimeconstraint_fast disobeyedtimeconstraint_slow if ((study=="6" & condition=="Time delay") | (study=="6" & condition=="Time pressure") | study=="1"), r
* ///////////////////////////


* ///////////////////////
* // STUDY 7
* // contribution in time pressure vs time delay conditions
* ranksum contribution if disobeyedtimeconstraint==0  & study=="7", by(condition)
* char condition [omit] "Time delay"
* xi: intreg cont0 cont1  i.condition if disobeyedtimeconstraint==0  & study=="7", r
* xi: intreg cont0 cont1  i.condition  age female  failedcomprehension if disobeyedtimeconstraint==0  & study=="7", r
* xi: intreg cont0 cont1  i.condition failedcomprehension age female  disobeyedtimeconstraint  if study=="7", r
* //     robust to controliing for prediction of avg contribution of other group members
* xi: intreg cont0 cont1  i.condition failedcomprehension age female  prediction if disobeyedtimeconstraint==0  & study=="7", r
* xi: intreg cont0 cont1  i.condition failedcomprehension age female  prediction disobeyedtimeconstraint if  study=="7", r
* // prediction in time pressure vs time delay conditions
* ranksum prediction if disobeyedtimeconstraint==0  & study=="7", by(condition )
* xi: intreg pred0 pred1 i.condition if disobeyedtimeconstraint==0  & study=="7", r
* xi: intreg pred0 pred1 i.condition failedcomprehension age i.female  if disobeyedtimeconstraint==0  & study=="7", r
* xi: intreg pred0 pred1 i.condition failedcomprehension age i.female  disobeyedtimeconstraint if   study=="7" , r
* // how does contribution compare to prediction?
* signrank contribution=prediction if disobeyedtimeconstraint==0 & study=="7" & condition=="Time delay"
* signrank contribution=prediction if disobeyedtimeconstraint==0 & study=="7" & condition=="Time pressure"
* ///////////////////////////////


* /////////////////////////////
* // STUDY 6 VS STUDY 7
* // to compare lab and AMT, contribution levels must be rescale (since lab had 10x higher stakes)
* gen contribution_normalized = contribution/400 if study=="7"
* replace contribution_normalized = contribution/40 if study~="7"
* // compare average normalized contribution in lab v AMT
* ranksum contribution_normalized  if (study=="6" | study=="7") & disobeyedtimeconstraint==0, by(study)
* ranksum contribution_normalized  if study=="6" | study=="7", by(study)
* //    using Tobit regression (need to create additional variables for intreg)
* gen contribution_normalized0 = contribution_normalized
* replace contribution_normalized0=. if contribution_normalized==0
* gen contribution_normalized1 = contribution_normalized
* replace contribution_normalized1=. if contribution_normalized==1
* char study [omit] "6"
* char condition [omit] "Time delay"
* xi: intreg contribution_normalized0 contribution_normalized1   i.study i.condition if (study=="6" | study=="7") & disobeyedtimeconstraint==0, r
* xi: intreg contribution_normalized0 contribution_normalized1   i.study i.condition age female i.educ usresident if (study=="6" | study=="7") & disobeyedtimeconstraint==0, r
* xi: intreg contribution_normalized0 contribution_normalized1   i.study*i.condition if (study=="6" | study=="7") & disobeyedtimeconstraint==0, r
* xi: intreg contribution_normalized0 contribution_normalized1   i.study*i.condition age female i.educ usresident if (study=="6" | study=="7") & disobeyedtimeconstraint==0, r
* /////////////////////////////////


////////////////////
// STUDY 8
// main effect of promoting intuition versus promoting reflection
//      for this analysis, we need dummies for 'promote intuition' and 'outcome valence'
gen promoteintuition=.
replace promoteintuition=1 if condition=="Intuition Good" | condition=="Reflection Bad"
replace promoteintuition=0 if condition=="Intuition Bad" | condition=="Reflection Good"
gen outcomevalence=.
replace outcomevalence=1 if condition=="Intuition Good" | condition=="Reflection Good"
replace outcomevalence=0 if condition=="Intuition Bad" | condition=="Reflection Bad"
//    contribution higher in promoteintuition
ranksum contribution if study=="8", by(promoteintuition)

// MAIN REPLICATION TEST
xi: intreg cont0 cont1 i.promoteintuition  if study=="8", r
matrix list r(table)
* xi: intreg cont0 cont1 i.promoteintuition outcomevalence  if study=="8", r
* xi: intreg cont0 cont1 i.promoteintuition outcomevalence usresident age female i.educ failedcomprehension paragraphlength if study=="8", r
* //      no interaction between promoteintuition and outcomevalence
* xi: intreg cont0 cont1 i.promoteintuition*outcomevalence if study=="8", r
* xi: intreg cont0 cont1 i.promoteintuition*outcomevalence usresident age female i.educ failedcomprehension paragraphlength if study=="8", r
* // interaction between cognitive style and outcome valence
* //      for this analysis, we need an additional dummy for 'reasoning style'
* gen reasoningstyle=.
* replace reasoningstyle=1 if condition=="Reflection Good" | condition=="Reflection Bad"
* replace reasoningstyle=0 if condition=="Intuition Good" | condition=="Intuition Bad"
* // crossover interaction using ANOVA
* xi: anova contribution outcomevalence reasoningstyle outcomevalence#reasoningstyle if study=="8"
////////////////////////////
sum contribution if promoteintuition==1 & study=="8"
sum contribution if promoteintuition==0 & study=="8"


* ////////////////////////
* // STUDY 9
* // Contribution level in conceptual priming experiment, naÔve vs experienced subjects.
* //        all subjects
* xi: intreg cont0 cont1  i.condition*naive  if study=="9"   , r
* xi: intreg cont0 cont1  i.condition*naive age i.female usresident i.educ failedcomprehension paragraphlength if study=="9"  , r
* //        naive subjects
* xi: intreg cont0 cont1  i.condition*naive  if study=="9" &   naive==1, r
* xi: intreg cont0 cont1  i.condition*naive age i.female usresident i.educ failedcomprehension paragraphlength  if study=="9"  & naive==1 , r
* //        experienced subjects
* xi: intreg cont0 cont1  i.condition*naive  if study=="9"  & naive==0, r
* xi: intreg cont0 cont1  i.condition*naive age i.female usresident i.educ failedcomprehension paragraphlength  if study=="9"  & naive==0  , r
* // Log10(Decision time) in conceptual priming experiment, naÔve subjects.
* xi: reg Ldecisiontime i.condition if study=="9" & naive==1, r
* xi: reg Ldecisiontime i.condition age i.female usresident i.educ failedcomprehension Linstructionstime paragraphlength  if study=="9"  & naive==1, r
* // Log10(Time reading instructions) in conceptual priming experiment, naÔve subjects.
* xi: reg Linstructionstime i.condition if study=="9"  & naive==1, r
* xi: reg Linstructionstime i.condition age i.female usresident i.educ failedcomprehension Ldecisiontime paragraphlength  if study=="9"  & naive==1, r
* // Contribution level in conceptual priming experiment as a function of decision time, naÔve subjects.
* xi: intreg cont0 cont1  Ldecisiontime  if study=="9" & naive==1, r
* xi: intreg cont0 cont1  Ldecisiontime age i.female usresident i.educ failedcomprehension paragraphlength if study=="9" & naive==1  , r
* xi: intreg cont0 cont1  i.condition if study=="9" & naive==1  , r
* xi: intreg cont0 cont1  i.condition age i.female usresident i.educ failedcomprehension paragraphlength if study=="9" & naive==1  , r
* xi: intreg cont0 cont1  Ldecisiontime i.condition age i.female usresident i.educ failedcomprehension paragraphlength if study=="9" & naive==1  , r
* //////////////////////////////


* ///////////////////////////////////////////////////////////
* // STUDY 10
* // trust doesnt vary w time
* xi: logit moretrustinghalf  Ldecisiontime if study=="10", r
* xi: logit moretrustinghalf  Ldecisiontime age i.female usresident i.educ failedcomprehension if study=="10", r
* // Contribution versus decision time for subjects with a less versus more positive view of people they interact with in daily life.
* xi: intreg cont0 cont1 Ldecisiontime i.moretrustinghalf*Ldecisiontime  if study=="10" , r
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension i.moretrustinghalf*Ldecisiontime  if study=="10" , r
* xi: intreg cont0 cont1 Ldecisiontime if study=="10"  & moretrustinghalf==1, r
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension i.moretrustinghalf*Ldecisiontime  if study=="10"  & moretrustinghalf==1, r
* xi: intreg cont0 cont1 Ldecisiontime if study=="10" & moretrustinghalf==0, r
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension i.moretrustinghalf*Ldecisiontime  if study=="10"  & moretrustinghalf==0, r
* // Contribution versus measures of individual differences in cognitive style.
* xi: intreg cont0 cont1 crtcorrect if study=="10", r
* xi: intreg cont0 cont1 crtcorrect age female usresident i.educ failedcomprehension  if study=="10", r
* xi: intreg cont0 cont1 needforcognition  if study=="10", r
* xi: intreg cont0 cont1 needforcognition  age i.female usresident i.educ failedcomprehension  if study=="10", r
* xi: intreg cont0 cont1 faithinintuition  if study=="10", r
* xi: intreg cont0 cont1 faithinintuition  age i.female usresident i.educ failedcomprehension  if study=="10", r
* // Log10(Decision time) versus measures of individual differences in cognitive style.
* xi: reg Ldecisiontime crtcorrect if study=="10", r
* xi: reg Ldecisiontime crtcorrect age female usresident i.educ failedcomprehension  if study=="10", r
* xi: reg Ldecisiontime needforcognition  if study=="10", r
* xi: reg Ldecisiontime needforcognition  age i.female usresident i.educ failedcomprehension  if study=="10", r
* xi: reg Ldecisiontime faithinintuition  if study=="10", r
* xi: reg Ldecisiontime faithinintuition  age i.female usresident i.educ failedcomprehension  if study=="10", r
* // Contribution versus decision time with additional controls
* xi: intreg cont0 cont1 Ldecisiontime if study=="10" , r
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension if study=="10" , r
* xi: intreg cont0 cont1 Ldecisiontime age i.female usresident i.educ failedcomprehension socialrisktaking generalrisktaking Linstructionstime if study=="10" , r
* ////////////////////////////////////


* ////////////////////////////////////////////////
* ////////////////////////////////////////////////
* // SUPPLEMENTAL STUDY
* // Contribution when comprehension questions are 'Before decision' vs 'After decision'
* ranksum contribution if study=="Supplemental", by(condition )
* xi: intreg cont0 cont1 i.condition age i.usresident female if study=="Supplemental", r
* // Log10(Decision time) when comprehension questions are 'Before decision' vs 'After decision'
* ranksum Ldecisiontime if study=="Supplemental", by(condition )
* xi: reg Ldecisiontime i.condition age i.usresident female if study=="Supplemental", r
* //      Less variance in log10(Decision time) in 'Before decision'
* sdtest Ldecisiontime if study=="Supplemental", by(condition )
* /////////////////////////////////////
