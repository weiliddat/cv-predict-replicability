clear all
set more off

use "Aviezer et al (2012) - Data.dta"

* ---------------------------------------------------------------------------- *
* Analysis
* ---------------------------------------------------------------------------- *
preserve
	replace vr = vr - 5
	
	qui gen vr_w = vr if wl == "pos"
  qui gen vr_l = vr if wl == "neg"
	
	qui collapse vr_w vr_l, by(id)
	tabstat vr_*, statistics(mean sem)

	ttest vr_w == vr_l
restore
