library(haven)
library(dplyr)
library(caret)

data <- read_dta("Morewedge et al (2010) - Data.dta")

ub <- mean(data$amount) + (2.5 * sd(data$amount))

data %>% 
  filter(amount < ub & amount != 0) %>% 
  lm(amount ~ treatment, data = .) %>% 
  summary()

data %>% 
  filter(amount < ub) %>% 
  lm(amount ~ treatment, data = .) %>% 
  summary()

### CV

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

cvFit <- data %>% 
  filter(amount < ub & amount != 0) %>%
  train(amount ~ treatment, data = ., trControl = cvControl, method = "lm", na.action = na.omit)

cvFit

summary(cvFit)


