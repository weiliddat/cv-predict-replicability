clear all

* New data
insheet using  "Shah et al (2012) - Data (Part 1).tsv"
* insheet using  "Shah et al (2012) - Data (Part 2).tsv"

* Original data
* import excel "../original_data/wheel-attention.xls", sheet("stroop") firstrow
* cleaning
* only needed for original data, rep data is already cleaned
rename *, lower
drop if total==0 


* Generate a varaible to group conditions in rich (rp=1) and poor (rp=0)
gen rp=.
* for poor
replace rp=0 if cond==0
replace rp=0 if cond==2
* for rich
replace rp=1 if cond==1
replace rp=1 if cond==3

* run ANOVA test
oneway total rp
display r(F)
bysort rp: sum total

// *robustness
// sum total
// drop if total < 20
// bysort rp: sum total
// oneway total rp
// display r(F)

* random sample instead of first observations
// sample 602, count
// oneway total rp
