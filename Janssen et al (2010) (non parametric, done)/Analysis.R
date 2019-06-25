library(haven)
library(dplyr)
library(caret)

data <- read_dta("Janssen et al (2010) - Earnings Data (edited).dta")

test <- wilcox.test(earnings ~ communication, data = data)
print(test)
# not sure if we need this?
# scalar  define  U1= r(sum_obs)-r(N_1)*(r(N_1)+1)/2
# scalar define U2=r(N_1)*r(N_2)-U1
# display in smcl as text "Mann-Whitney U = " as result max(U1, U2)
signed_rank = function(x) sign(x) * rank(abs(x))

test_lm <- lm(rank(earnings) ~ 1 + communication, data = data)
summary(test_lm)



library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(rank(earnings) ~ 1 + communication, data = data, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)
