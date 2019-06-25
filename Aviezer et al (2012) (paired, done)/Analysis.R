library(haven)
library(dplyr)
library(caret)
library(tidyr)

data <- read_dta("Aviezer et al (2012) - Data.dta")

transformed <- data %>% 
  group_by(id, wl) %>% 
  summarise(vr = mean(vr)) %>% 
  mutate(
    vr_w = if_else(wl == "pos", vr, NULL),
    vr_l = if_else(wl == "neg", vr, NULL)
  ) %>% 
  summarise(
    vr_w = mean(vr_w, na.rm = TRUE),
    vr_l = mean(vr_l, na.rm = TRUE)
  ) %>% 
  data.table::melt(id.vars = "id", measure.vars = c("vr_w", "vr_l"), variable.name = "winlose")
  

data %>%
  mutate(
    vr_w = if_else(wl == "pos", vr - 5, NULL),
    vr_l = if_else(wl == "neg", vr - 5, NULL)
  ) %>% 
  group_by(id) %>% 
  summarise(
    vr_w = mean(vr_w, na.rm = TRUE),
    vr_l = mean(vr_l, na.rm = TRUE)
  )

data %>% 
  group_by(id, wl) %>% 
  summarise(vr = mean(vr)) %>% 
  mutate(
    vr_w = if_else(wl == "pos", vr, NULL),
    vr_l = if_else(wl == "neg", vr, NULL)
  ) %>% 
  summarise(
    vr_w = mean(vr_w, na.rm = TRUE),
    vr_l = mean(vr_l, na.rm = TRUE)
  ) %>% 
  { t.test(.$vr_w, .$vr_l, paired = TRUE) }

transformed %>%
  { lm(value ~ winlose, data = .) } %>% 
  summary()

library(lmerTest)

transformed %>%
  { lmer(value ~ 1 + winlose + (1|id), data = .) } %>% 
  summary()


cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(value ~ winlose, data = transformed, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)
