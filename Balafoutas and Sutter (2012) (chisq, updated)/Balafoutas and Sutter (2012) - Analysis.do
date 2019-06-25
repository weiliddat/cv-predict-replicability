clear all
set more off

use "Balafoutas and Sutter (2012) - Data.dta"


* ---------------------------------------------------------------------------- *
* Main Result: Chi2-Test
* ---------------------------------------------------------------------------- *
preserve
	drop if gender == 1
	keep if period == 3
	
	sum choice if treatment == "Control"
	sum choice if treatment == "Preferential"

	tab choice treatment, chi2
restore



* Test for Order Effects
* ---------------------------------------------------------------------------- *
preserve
	bysort treatment: prtest choice, by(order)
restore

* Test for Differences in Correct Answers
* ---------------------------------------------------------------------------- *
preserve
	bysort period: ttest correct, by(gender)
restore
