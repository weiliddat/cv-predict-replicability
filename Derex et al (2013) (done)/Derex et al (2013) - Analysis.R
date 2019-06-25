library(haven)
library(caret)

data <- read_dta("Derex et al (2013) - Data.dta")

fit <- glm(bothtasks ~ groupsize + meanage, family = "binomial", data = data)

fit

summary(fit)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(bothtasks ~ groupsize + meanage, data = data, trControl = cvControl, method = "glm", na.action = na.omit)

print(fit1)
summary(fit1)
