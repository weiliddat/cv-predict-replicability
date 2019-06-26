library(readr)
library(dplyr)
library(caret)

data <- read_csv("Ackerman et al. (2010) - Replicaiton Data .csv")
#to deal with imputed values, I believe, we created a new .csv file "Ackerman et al. (2010) - Updated_resolved.csv". 

data %>%
  filter(Collection == 1) %>%
  filter(Exc_resolved == 0) %>% #line updated by Arianne
  (function(x) {
    xh <- x %>% filter(Condition == "H") %>% select("DV") %>% as.data.frame()
    xl <- x %>% filter(Condition == "L") %>% select("DV") %>% as.data.frame()

    t.test(xh, xl)
  }) -> test1

data %>%
  filter(Exc_resolved == 0) %>%  #line updated by Arianne
  (function(x) {
    xh <- x %>% filter(Condition == "H") %>% select("DV") %>% as.data.frame()
    xl <- x %>% filter(Condition == "L") %>% select("DV") %>% as.data.frame()
    
    t.test(xh, xl)
  }) -> test2

print(test1)

print(test2)

lm(DV ~ Condition, data) %>% summary()
lm(DV ~ Condition, data[which(data$Exc_resolved == 0),]) %>% summary() #To account for the extra filter in lines 10 & 19.

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
