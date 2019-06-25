library(readr)
library(dplyr)
library(caret)

# Part 1
data1 <- read_tsv("Rand et al. (2012) - Data (Part 1).tsv")

data1 %>% 
  mutate(promoteintuition = case_when(
    Condition == "Intuition Good" | Condition == "Reflection Bad" ~ 1,
    Condition == "Intuition Bad" | Condition == "Reflection Good" ~ 0
  )) %>% 
  wilcox.test(Contribution ~ promoteintuition, data = .)

# Pooled results
data2 <- read_tsv("Rand et al. (2012) - Data (Part 2).tsv")

transformed2 <- data2 %>% 
  mutate(promoteintuition = case_when(
    Condition == "Intuition Good" | Condition == "Reflection Bad" ~ 1,
    Condition == "Intuition Bad" | Condition == "Reflection Good" ~ 0
  ))

# study used tobit regression

wilcox.test(Contribution ~ promoteintuition, data = transformed2)


test_lm <- lm(rank(Contribution) ~ 1 + promoteintuition, data = transformed2)
summary(test_lm)

library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(rank(Contribution) ~ 1 + promoteintuition, data = transformed2, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)
