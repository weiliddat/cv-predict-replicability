*REPLICATION ANALYSIS
*Based on original document
*Core State code for nature15392: "Inequality and Visibility of Wealth in Experimental Social Networks"
*Written by Akihiro Nishi (akihiro.nishi@yale.edu) at September 2015

*******************************************************************************
*Procedure I: Session-level results using session_data.csv (Figs. 2 and 3)
*******************************************************************************

*******************************************************************************
*Step A: Data infile
cls
clear all
insheet using "Nishi et al (2015) - Session Data (Replication).csv"

*******************************************************************************
*Step B: Variable creation
destring gini_all, replace force 
destring gmd_all, replace force 
destring cumulativepayoff_all, replace force 
destring behavior_all, replace force 
destring degree_all, replace force 
destring trans_all, replace force

*Visibility ("invisible":1:invisible,0:visible)
gen visible = .
replace visible = 1 if showscore == "true"
replace visible = 0 if showscore == "false"

*Initial wealth inequality
gen gini = "0.4" if scorea == 1150

gen gini2 = .
replace gini2 = 0.4 if gini == "0.4"

*******************************************************************************
*Step C (Analysis): Gini coefficient (Fig. 2)
*Fig. 2 inset (Supplementary Table 2 [3-5])
* MAIN REPLICATION TEST! * 
eststo: quietly xi: cluster2 gini_all i.visible if round >=1, fcluster(game) tcluster(round)
* Extra test: control for i.round
eststo: quietly xi: cluster2 gini_all i.visible i.round if round >=1, fcluster(game) tcluster(round)
* Extra test: one-way clustering
eststo: quietly xi: regress gini_all i.visible if round >=1, vce(cluster game)
* Extra test: one-way cluster with round fixed effects
eststo: quietly xi: regress gini_all i.visible i.round if round >=1, vce(cluster game)

* Table
esttab, se compress label ///
	indicate(Round dummies = _Iround*) ///
	addnote("For (1) and (2) standard errors are clustered on both game and round," "for (3) and (4) only on game.")

* Extra test: T test of means
drop if round < 1
bysort game: egen mean_gini = mean(gini_all)
ttest mean_gini if round==1, by(visible)
ttest mean_gini if round==1, unequal by(visible)

* Extra run extra regressions on original data
clear all
insheet using "Nishi et al (2015) - Session Data (Original).csv"
quietly destring gini_all, replace force 
quietly destring gmd_all, replace force 
quietly destring cumulativepayoff_all, replace force 
quietly destring behavior_all, replace force 
quietly destring degree_all, replace force 
quietly destring trans_all, replace force

quietly gen visible = .
quietly replace visible = 1 if showscore == "true"
quietly replace visible = 0 if showscore == "false"

quietly generate gini = "0.4" if scorea == 1150

quietly gen gini2 = .
quietly replace gini2 = 0.4 if gini == "0.4"

eststo clear
eststo: quietly xi: cluster2 gini_all i.visible if gini == "0.4" & round >=1, fcluster(game) tcluster(round)
eststo: quietly xi: cluster2 gini_all i.visible i.round if gini == "0.4" & round >=1, fcluster(game) tcluster(round)
eststo: quietly xi: regress gini_all i.visible if gini == "0.4" & round >=1, vce(cluster game)
eststo: quietly xi: regress gini_all i.visible i.round if gini == "0.4" & round >=1, vce(cluster game)

esttab, se compress label ///
	indicate(Round dummies = _Iround*) ///
	addnote("For (1) and (2) standard errors are clustered on both game and round," "for (3) and (4) only on game.")

drop if round < 1
bysort game: egen mean_gini = mean(gini_all)
ttest mean_gini if gini =="0.4" & round==1, by(visible)
ttest mean_gini if gini =="0.4" & round==1, unequal by(visible)

*******************************************************************************
*Procedure II: Individual behaviors using individual_data.csv (Fig. 4)
*******************************************************************************

*******************************************************************************
*Step A: Data infile (Rounds 2-10 data at the individual level)
clear all
insheet using "Nishi et al (2015) - Individual Data (Replication).csv"

* EXTRA (BUG IN REP GAME 8?)
destring initial_score, replace force
drop if round < 2

*******************************************************************************
*Step B: Variable creation
*Cooperation behavior ("coop", 1:C, 0:D)
destring behavior, replace force
gen coop = behavior

*Wealth ("wealth")
gen wealth = cumulativepayoff

*Visibility ("visible", 1:visible, 0:invisible)
gen visible = .
replace visible = 1 if showscore == "true"
replace visible = 0 if showscore == "false"

*GINI coefficient ("gini")
gen gini = "0.4" if scorea == 1150

gen gini2 = 0.0 if scorea == 500
replace gini2 = 0.2 if scorea == 700 | scorea == 850
replace gini2 = 0.4 if scorea == 1150

*Initial score ("initial": endowment)
replace initial_score = initial_score
gen initial_score2 = initial_score/100

*Ego's cooperation behavior at the end of the prior round ("prev_coop", 1:C, 0:D)
destring e_behavior, replace force
gen prev_coop = e_behavior
* tab prev_coop, missing

*Wealth at the end of the prior round ("prev_wealth")
destring e_cumulativepayoff, replace force
gen prev_wealth = e_cumulativepayoff
gen prev_wealth2 = prev_wealth/100

*Degree at the end of the prior round ("e_degree")
destring e_degree, replace force

*Wealth difference at the end of the prior round (ego is richer:1: "richer_e")
*We call this indicator variable as a "social comparison" variable.
destring local_avg_wealth, replace force
gen alter_minus_ego_wealth = local_avg_wealth - prev_wealth

gen richer_e = .
replace richer_e = 1 if alter_minus_ego_wealth <= 0 /*alter <= ego  */
replace richer_e = 0 if alter_minus_ego_wealth > 0 /*alter > ego  */

*Local cooperation rate at last move (>=50%:1 : "local_rate_coop2")
destring local_rate_coop, replace force

gen local_rate_coop2 = .
replace local_rate_coop2 = 1 if local_rate_coop >= 0.5 & local_rate_coop !=.
replace local_rate_coop2 = 0 if local_rate_coop < 0.5  & local_rate_coop !=.

*Two-way interaction term (wealth difference x initial Gini)
gen int_ric_gin2 = richer_e*gini2

*******************************************************************************
*Step C (Analysis): Gini coefficient (Fig. 4)
eststo clear
*Supplementary Table 7 (5): Invisible, Initial Gini = 0.4, Fig. 4-3
eststo: quietly xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==0 & (initial_score == 1150 | initial_score ==200), fcluster(game) tcluster(round)
*Supplementary Table 7 (8): Visible, Initial Gini = 0.4, Fig. 4-6
eststo: quietly xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==1 & (initial_score == 1150 | initial_score ==200), fcluster(game) tcluster(round)

esttab, se compress label nonotes ///
	addnotes("Standard errors clustered on game and round in parenthesis") ///
	nonumbers mtitles("Model (5)" "Model (8)")  
