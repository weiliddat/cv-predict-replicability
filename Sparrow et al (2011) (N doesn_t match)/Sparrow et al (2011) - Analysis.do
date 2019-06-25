set more off


* ---------------------------------------------------------------------------- *
* Stage 1: Within-Subject t-Test
* ---------------------------------------------------------------------------- *
clear all
use  "Sparrow et al (2011) - Data.dta"
drop if id > 104

* only keep data after hard trivia questions
carryforward  order, replace
drop if order == 1 & n == 1
drop if order == 2 & n == 2

* drop if color naming was incorrect
drop if acc == 0

* separate variables for target and unrealated words
gen rt_rel = time if ttype == 1
gen rt_unr = time if ttype == 0

label   var rt_rel   "Reaction Time Target Words"
label   var rt_unr   "Reaction Time Unrelated Words"

collapse rt_*, by(id)
ttest rt_rel == rt_unr

* ---------------------------------------------------------------------------- *
* Stage 1: Additional Result (only 24 first trials)
* ---------------------------------------------------------------------------- *
clear all
use  "Sparrow et al (2011) - Data.dta"
drop if id > 104

* only keep data after hard trivia questions
carryforward  order, replace
drop if order == 1 & n == 1
drop if order == 2 & n == 2

* drop if color naming was incorrect
drop if acc == 0

* drop trials 25-48
drop if trial > 24

* separate variables for target and unrealated words
gen rt_rel = time if ttype == 1
gen rt_unr = time if ttype == 0

label   var rt_rel   "Reaction Time Target Words"
label   var rt_unr   "Reaction Time Unrelated Words"

collapse rt_*, by(id)
ttest rt_rel == rt_unr



* ---------------------------------------------------------------------------- *
* Stage 2: Within-Subject t-Test
* ---------------------------------------------------------------------------- *
clear all
use  "Sparrow et al (2011) - Data.dta"

* only keep data after hard trivia questions
carryforward  order, replace
drop if order == 1 & n == 1
drop if order == 2 & n == 2

* drop if color naming was incorrect
drop if acc == 0

* separate variables for target and unrealated words
gen rt_rel = time if ttype == 1
gen rt_unr = time if ttype == 0

label   var rt_rel   "Reaction Time Target Words"
label   var rt_unr   "Reaction Time Unrelated Words"

collapse rt_*, by(id)
ttest rt_rel == rt_unr

* ---------------------------------------------------------------------------- *
* Stage 2: Additional Result (only 24 first trials)
* ---------------------------------------------------------------------------- *
clear all
use  "Sparrow et al (2011) - Data.dta"

* only keep data after hard trivia questions
carryforward  order, replace
drop if order == 1 & n == 1
drop if order == 2 & n == 2

* drop if color naming was incorrect
drop if acc == 0

* drop trials 25-48
drop if trial > 24

* separate variables for target and unrealated words
gen rt_rel = time if ttype == 1
gen rt_unr = time if ttype == 0

label   var rt_rel   "Reaction Time Target Words"
label   var rt_unr   "Reaction Time Unrelated Words"

collapse rt_*, by(id)
ttest rt_rel == rt_unr
