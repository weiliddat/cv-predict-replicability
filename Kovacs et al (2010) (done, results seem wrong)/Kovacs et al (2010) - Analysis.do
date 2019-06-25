use "Kovacs et al (2010) - Data.dta", clear

*** p0a0 is the P-A- treatment, p0a1 is the P-A+ treatment ***
* 1. generate response time (rt), starting point is at the 18.16 second (18160 ms) 
gen rtp0a0=p0a0-18160
gen rtp0a1=p0a1-18160

* 2. calculate mean response time by participant
collapse p0a0 rtp0a0 p0a1 rtp0a1, by(participant) 

*** Results: using data of all 95 participants ***
ttest rtp0a0=rtp0a1

*** Results: using data of the 90 participants with no more than one invalid or missing reaction times***
ttest rtp0a0=rtp0a1 if participant~=16 & participant~=25 & participant~=46 & participant~=69 & participant~=85
