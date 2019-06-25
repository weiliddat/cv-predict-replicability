library(haven)
library(dplyr)
library(caret)
library(tidyr)

data <- read_dta("Kovacs et al (2010) - Data.dta")

data %>% 
  mutate(rtp0a0 = p0a0 - 18160, rtp0a1 = p0a1 - 18160) %>% 
  group_by(participant) %>%
  summarise(
    p0a0 = mean(p0a0),
    p0a1 = mean(p0a1),
    rtp0a0 = mean(rtp0a0),
    rtp0a1 = mean(rtp0a1)
  ) %>% 
  lm(rtp0a1 - rtp0a0 ~ 1, data = .) %>% 
  summary()

### CV

transformed1 <- data %>%
  mutate(rtp0a0 = p0a0 - 18160, rtp0a1 = p0a1 - 18160) %>% 
  group_by(participant) %>%
  summarise(
    p0a0 = mean(p0a0),
    p0a1 = mean(p0a1),
    rtp0a0 = mean(rtp0a0),
    rtp0a1 = mean(rtp0a1)
  )

transformed2 <- data %>% 
  mutate(rtp0a0 = p0a0 - 18160, rtp0a1 = p0a1 - 18160) %>% 
  group_by(participant) %>%
  summarise(
    p0a0 = mean(p0a0),
    p0a1 = mean(p0a1),
    rtp0a0 = mean(rtp0a0),
    rtp0a1 = mean(rtp0a1)
  ) %>% 
  gather(rtp0a0, rtp0a1, key = "treatment", value = "rt")

t.test(transformed1$rtp0a0, transformed1$rtp0a1, paired = TRUE)
lm(rtp0a0 ~ rtp0a1, data = transformed1) %>% summary()
lm(rt ~ treatment, data = transformed2) %>% summary()

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

cvFit <- train(rt ~ treatment, data = transformed2, trControl = cvControl, method = "lm", na.action = na.omit)

cvFit

summary(cvFit)

###

excluded = c(16, 25, 46, 69, 85)

data %>% 
  mutate(rtp0a0 = p0a0 - 18160, rtp0a1 = p0a1 - 18160) %>% 
  group_by(participant) %>%
  summarise(
    p0a0 = mean(p0a0),
    p0a1 = mean(p0a1),
    rtp0a0 = mean(rtp0a0),
    rtp0a1 = mean(rtp0a1)
  ) %>% 
  filter(!participant %in% excluded) %>% 
  lm(rtp0a0 ~ rtp0a1, data = .) %>% 
  summary()
