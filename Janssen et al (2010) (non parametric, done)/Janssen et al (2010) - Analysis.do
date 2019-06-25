//calculating the total tokens of collected by a group in each round
** total1: total token earnings of a group in round 1
** total2: total token earnings of a group in round 2
** total3: total token earnings of a group in round 3
** communication: dummy for communication

use "Janssen et al (2010) - Data.dta", clear

bysort communication session group: gen total1=sum(earning1)
bysort communication session group: gen total2=sum(earning2)
bysort communication session group: gen total3=sum(earning3)

bysort communication session group: egen tmax1=max(total1)
bysort communication session group: egen tmax2=max(total2)
bysort communication session group: egen tmax3=max(total3)

keep if total1==tmax1
keep communication session group total*

save "Janssen et al (2010) - Earnings Data.dta", replace


*** Mann-Whitney U test ***
use "Janssen et al (2010) - Earnings Data (edited).dta", clear

ranksum earnings, by(communication)

scalar  define  U1= r(sum_obs)-r(N_1)*(r(N_1)+1)/2
scalar define U2=r(N_1)*r(N_2)-U1
display in smcl as text "Mann-Whitney U = " as result max(U1, U2)
