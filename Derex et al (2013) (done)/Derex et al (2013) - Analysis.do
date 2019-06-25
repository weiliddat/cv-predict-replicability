use "Derex et al (2013) - Data.dta", clear

* bothtasks: 1 for presence of diversity in the last three periods, 0 for absense of diversity in the last three periods 
* groupsize: group size
* replicate: replicate number
* meanage: mean age within the group

//generalized linear model (binomial) to test the maintanance of cultural diversity
glm bothtasks groupsize meanage, family(binomial)
test groupsize

