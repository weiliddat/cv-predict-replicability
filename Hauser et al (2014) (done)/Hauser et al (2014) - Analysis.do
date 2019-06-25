********************************************************************************
********************************************************************************
* DO FILE FOR MAIN ANALYSIS *
********************************************************************************
********************************************************************************

clear all

********************************************************************************
*All generations together
********************************************************************************
use "Hauser et al (2014) - Data (All Generations).dta"

****** 1. First Generation 55 observations * 2 treatments if Generation==1
reg sustained i.Voting if (Condition ==1 | Condition==2) & Generation==1, robust
matrix list r(table)
****** 2. First Generation: 31 groups - all obs included (except 2 from free treatment  - since 82 subjects)
reg sustained_add i.Voting if (Condition ==1 | Condition==2) & Generation==1, robust
matrix list r(table)
****** 3. First Generation: 30 Groups  - 5 obs not included, 2 from free treatment + 3 recruited extra to voting treatment
reg sustained_noextra i.Voting if (Condition ==1 | Condition==2) & Generation==1, robust
matrix list r(table)

****** 4. All Generations 
reg sustained i.Voting if (Condition ==1 | Condition==2), robust
matrix list r(table)
****** 5. All Generations  - pooled
reg sustained i.Voting if (Condition ==1 | Condition==2), vce(cluster pool_unique)
matrix list r(table)
****** 6. All Generations  - inc extra
reg sustained_addt i.Voting if (Condition ==1 | Condition==2), robust
matrix list r(table)
****** 7. All Generations  - pooled, inc extra
reg sustained_addt i.Voting if (Condition ==1 | Condition==2), vce(cluster pool_unique)
