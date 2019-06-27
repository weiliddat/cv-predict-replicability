library(haven)
library(dplyr)
library(caret)

data <- read_dta("Hauser et al (2014) - Data (All Generations).dta")

# Note: R doesn't have a robust option for lm

# 1.
data %>% #Arianne comment: #1 yields the output values reported in final SSRP data (i.e. t(20)=6.7082, p=1.58E-06).
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(.$Generation == 1) %>%
  filter(!is.na(sustained)) %>% 
  lm(sustained ~ Voting, data = .) %>% 
  summary()

# 2.
data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(.$Generation == 1) %>% 
  filter(!is.na(sustained_add)) %>% 
  lm(sustained_add ~ Voting, data = .) %>% 
  summary()

# 3.
data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(.$Generation == 1) %>% 
  filter(!is.na(sustained_noextra)) %>% 
  lm(sustained_noextra ~ Voting, data = .) %>% 
  summary()

###
# Main result is generation 1 only

control <- trainControl(method = "repeatedcv", number = 10, repeats = 5)

model <- data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(.$Generation == 1) %>% 
  filter(!is.na(sustained_noextra)) %>% #Arianne comment: Pretty certain that this should be "sustained" NOT "substained_noextra" (see line 10 above).
  train(sustained_noextra ~ Voting, data = ., trControl = control, method = "lm")

model

summary(model)

###

# 4.
data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(!is.na(sustained)) %>% 
  lm(sustained ~ Voting, data = .) %>% 
  summary()

# 5. @todo vcov vce cluster and pool_unique
data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(!is.na(sustained)) %>% 
  lm(sustained ~ Voting, data = ., ) %>% 
  summary()

# 6.
data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(!is.na(sustained_addt)) %>% 
  lm(sustained_addt ~ Voting, data = .) %>% 
  summary()

# 7. @todo vcov vce cluster and pool_unique
data %>% 
  filter(.$Condition == 1 | .$Condition == 2) %>% 
  filter(!is.na(sustained_addt)) %>% 
  lm(sustained_addt ~ Voting, data = .) %>% 
  summary()
