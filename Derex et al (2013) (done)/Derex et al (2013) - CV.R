library(haven)
library(caret)

data <- read_dta("Derex et al (2013) - Data.dta")

fit <- glm(bothtasks ~ groupsize + meanage, family = "binomial", data = data)

fit

summary(fit)

control <- trainControl(method = "repeatedcv", number = 10, repeats = 5)

model <- train(bothtasks ~ groupsize + meanage, data = data, trControl = control, method = "glm", family = "binomial")

summary(model)
model$results$RMSE
model$results$Rsquared
