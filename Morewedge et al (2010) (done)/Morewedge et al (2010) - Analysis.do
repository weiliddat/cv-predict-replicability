clear all
set more off

use "Morewedge et al (2010) - Data.dta"


* ---------------------------------------------------------------------------- *
* Focal Hypothesis: Two-Sample t-Testt
* ---------------------------------------------------------------------------- *
preserve
	* drop observations larger than mean + 2.5 std
	qui  sum  amount, det
	loc  ub = r(mean) + 2.5 * r(sd)
	dis  "Mean + 2.5 SD: `ub'"
	drop if amount >= `ub'
	
	* drop observations with consumption equal to zero
	drop if amount == 0

	ttest amount, by(treatment)
restore


* ---------------------------------------------------------------------------- *
* Additional Result: Not Excluding 0-Consumption
* ---------------------------------------------------------------------------- *
preserve
	* drop observations larger than mean + 2.5 std
	qui  sum  amount, det
	loc  ub = r(mean) + 2.5 * r(sd)
	dis  "Mean + 2.5 SD: `ub'"
	drop if amount >= `ub'

	ttest amount, by(treatment)
restore
