library(haven)
library(dplyr)
library(tidyr)

data <- read_dta("Balafoutas and Sutter (2012) - Data.dta")

data %>% 
  filter(
    gender != 1,
    period == 3
  ) %>%
  group_by(treatment) %>% 
  summarise(
    choice = sum(choice)
  ) %>% 
  spread(treatment, choice) %>% 
  chisq.test()

data %>% 
  filter(
    gender != 1,
    period == 3
  ) %>%
  group_by(treatment) %>% 
  summarise(
    choice = sum(choice)
  ) %>% 
  spread(treatment, choice) %>% 
  {binom.test(c(.$Control, .$Preferential))}

matrix(c(44, 76, 63, 60), nrow = 2, byrow = TRUE) %>% 
  chisq.test(correct = FALSE)

data %>% 
  filter(
    gender != 1,
    period == 3
  ) %>%
  group_by(treatment)


glmod <- glm(choice ~ treatment, family = "binomial", data = data)
summary(glmod)

# doesn't seem right - is group the right variable?

library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(choice ~ group, data = data, trControl = cvControl, method = "glm", na.action = na.omit)

print(fit1)
summary(fit1)