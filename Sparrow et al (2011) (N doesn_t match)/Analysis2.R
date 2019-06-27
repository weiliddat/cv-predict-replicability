library(haven)
library(dplyr)
library(caret)
library(psych)
library(zoo)
library(tidyr)

data <- read_dta("Sparrow et al (2011) - Data.dta")

# Using LM
data %>% 
  filter(!(id > 104)) %>% 
  filter(!(order == 1 & n == 1)) %>% 
  filter(!(order == 2 & n == 2)) %>% 
  filter(!(acc == 0)) %>% 
  mutate(
    rt_rel = case_when(
      ttype == 1 ~ time
    ),
    rt_unr = case_when(
      ttype == 0 ~ time
    )
  ) %>% 
  group_by(id) %>% 
  summarise(
    rt_rel = mean(rt_rel, na.rm = TRUE),
    rt_unr = mean(rt_unr, na.rm = TRUE)
  ) %>% 
  lm(rt_rel ~ rt_unr, data = .) %>% 
  summary()

# Stage 1
data %>% 
  filter(!(id > 104)) %>% 
  filter(!(order == 1 & n == 1)) %>% 
  filter(!(order == 2 & n == 2)) %>% 
  filter(!(acc == 0)) %>% 
  mutate(
    rt_rel = case_when(
      ttype == 1 ~ time
    ),
    rt_unr = case_when(
      ttype == 0 ~ time
    )
  ) %>% 
  group_by(id) %>% 
  summarise(
    rt_rel = mean(rt_rel, na.rm = TRUE),
    rt_unr = mean(rt_unr, na.rm = TRUE)
  ) %>% 
  { t.test(.$rt_rel, .$rt_unr, paired = TRUE) }

# Stage 2
data %>% 
  filter(!(order == 1 & n == 1)) %>%
  filter(!(order == 2 & n == 2)) %>%
  filter(!(acc == 0)) %>%
  mutate(
    rt_rel = case_when(
      ttype == 1 ~ time
    ),
    rt_unr = case_when(
      ttype == 0 ~ time
    )
  ) %>% 
  group_by(id) %>% 
  summarise(
    rt_rel = mean(rt_rel, na.rm = TRUE),
    rt_unr = mean(rt_unr, na.rm = TRUE)
  ) %>% 
  { t.test(.$rt_rel, .$rt_unr, paired = TRUE) }

transformed <- data %>% 
  mutate(order_filled = na.locf(order)) %>% 
  filter(!(order_filled == 1 & n == 1)) %>% 
  filter(!(order_filled == 2 & n == 2)) %>% 
  filter(!(acc == 0)) %>% 
  mutate(
    rt_rel = case_when(
      ttype == 1 ~ time
    ),
    rt_unr = case_when(
      ttype == 0 ~ time
    )
  ) %>% 
  group_by(id) %>% 
  summarise(
    rt_rel = mean(rt_rel, na.rm = TRUE),
    rt_unr = mean(rt_unr, na.rm = TRUE)
  )

lm(transformed$rt_rel - transformed$rt_unr ~ 1, data = transformed) %>% 
  summary()

describe(transformed)

### CV
transformed2 <- transformed %>%
  gather(rt_rel, rt_unr, key = "treatment", value = "rt")


cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)
fit1 <- train(rt ~ treatment, data = transformed2, trControl = cvControl, method = "lm")

print(fit1)
summary(fit1)
    
str(fit1)
rmse.std <- fit1$results$RMSE/fit1$results$RMSESD

# RMSE is measured in the same units as our outcome. Defining a standardized rmse: Dividing the RMSE by its SD across cross-validation samples: rmse.std. Another sensible approach to interpret the RMSE is to divide it by the mean of our outcome variable so we can interpret in terms of percentage of the mean: perc.mean.rmse:

RMSE.STD <- function(fit1){
  rmse.std <- fit1$results$RMSE/fit1$results$RMSESD
  perc.mean.rmse <- fit1$results$RMSE/mean(fit1$trainingData$.outcome)
  list(rmse.std=rmse.std, perc.mean.rmse=perc.mean.rmse)
  }

RMSE.STD(fit1)

