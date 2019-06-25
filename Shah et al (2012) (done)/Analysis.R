library(readr)
library(dplyr)
library(caret)

# Part 1
data1 <- read_tsv("Shah et al (2012) - Data (Part 1).tsv")

data1 %>% 
  filter(total != 0) %>% 
  mutate(rp = case_when(
    cond == 0 | cond == 2 ~ 0,
    cond == 1 | cond == 3 ~ 1
  )) %>% 
  lm(total ~ rp, data = .) %>% 
  summary()

# Pooled
data2 <- read_tsv("Shah et al (2012) - Data (Part 2).tsv")

data2 %>% 
  filter(total != 0) %>% 
  mutate(rp = case_when(
    cond == 0 | cond == 2 ~ 0,
    cond == 1 | cond == 3 ~ 1
  )) %>% 
  lm(total ~ rp, data = .) %>% 
  summary()

transformed2 <- data2 %>% 
  filter(total != 0) %>% 
  mutate(rp = case_when(
    cond == 0 | cond == 2 ~ 0,
    cond == 1 | cond == 3 ~ 1
  ))

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(total ~ rp, data = transformed2, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)
