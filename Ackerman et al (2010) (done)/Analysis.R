library(readr)
library(dplyr)
library(caret)

data <- read_csv("Ackerman et al. (2010) - Replicaiton Data .csv")

data %>%
  filter(Collection == 1) %>%
  (function(x) {
    xh <- x %>% filter(Condition == "H") %>% select("DV") %>% as.data.frame()
    xl <- x %>% filter(Condition == "L") %>% select("DV") %>% as.data.frame()

    t.test(xh, xl)
  }) -> test1

data %>%
  (function(x) {
    xh <- x %>% filter(Condition == "H") %>% select("DV") %>% as.data.frame()
    xl <- x %>% filter(Condition == "L") %>% select("DV") %>% as.data.frame()
    
    t.test(xh, xl)
  }) -> test2

print(test1)

print(test2)

lm(DV ~ Condition, data) %>% summary()

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(DV ~ Condition, data = data, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)

looControl <- trainControl(
  method = "LOOCV"
)

fit2 <- train(DV ~ Condition, data = data, trControl = looControl, method = "lm", na.action = na.omit)

print(fit2)
summary(fit2)
