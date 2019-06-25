clear all
set more off


* ---------------------------------------------------------------------------- *
* Stage 1: Within-Subject t-Test
* ---------------------------------------------------------------------------- *
clear all
use "Duncan et al (2012) - Data.dta"

preserve
	drop   if id > 36
	
	keep if ttype == "similar"
	keep if prec_ttype == "old" | prec_ttype == "new"


	gen  if_p_new = accuracy if prec_ttype == "new"
	gen  if_p_old = accuracy if prec_ttype == "old"

	collapse if_p_new if_p_old, by(id)
	ttest    if_p_new == if_p_old
restore

* additional result based on preceding response
preserve
	gen  prec_response = response[_n-1]
	
	keep if ttype == "similar"
	keep if prec_response == "old" | prec_response == "new"


	gen  if_p_new = accuracy if prec_response == "new"
	gen  if_p_old = accuracy if prec_response == "old"

	collapse if_p_new if_p_old, by(id)
	ttest    if_p_new == if_p_old
restore



* ---------------------------------------------------------------------------- *
* Stage 2: Within-Subject t-Test
* ---------------------------------------------------------------------------- *
clear all
use "Duncan et al (2012) - Data.dta"

preserve
	keep if ttype == "similar"
	keep if prec_ttype == "old" | prec_ttype == "new"


	gen  if_p_new = accuracy if prec_ttype == "new"
	gen  if_p_old = accuracy if prec_ttype == "old"

	collapse if_p_new if_p_old, by(id)
	ttest    if_p_new == if_p_old
restore

* additional result based on preceding response
preserve
	gen  prec_response = response[_n-1]
	
	keep if ttype == "similar"
	keep if prec_response == "old" | prec_response == "new"


	gen  if_p_new = accuracy if prec_response == "new"
	gen  if_p_old = accuracy if prec_response == "old"

	collapse if_p_new if_p_old, by(id)
	ttest    if_p_new == if_p_old
restore

