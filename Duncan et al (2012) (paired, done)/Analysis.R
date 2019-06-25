library(haven)
library(dplyr)
data <- read_dta("Duncan et al (2012) - Data.dta")

data %>%
  filter(id <= 36) %>% 
  filter(ttype == "similar") %>% 
  filter(prec_ttype == "old" | prec_ttype == "new") %>% 
  mutate(
    if_p_new = if_else(prec_ttype == "new", accuracy, NULL),
    if_p_old = if_else(prec_ttype == "old", accuracy, NULL)
  ) %>% 
  group_by(id) %>% 
  summarise(
    if_p_new = mean(if_p_new, na.rm = TRUE),
    if_p_old = mean(if_p_old, na.rm = TRUE)
  ) %>% 
  { t.test(.$if_p_new, .$if_p_old, paired = TRUE) }

data %>% 
  mutate(
    prec_response = lag(response)
  ) %>% 
  filter(ttype == "similar") %>% 
  filter(prec_response == "old" | prec_response == "new") %>% 
  mutate(
    if_p_new = if_else(prec_response == "new", accuracy, NULL),
    if_p_old = if_else(prec_response == "old", accuracy, NULL)
  ) %>%
  group_by(id) %>%
  summarise(
    if_p_new = mean(if_p_new, na.rm = TRUE),
    if_p_old = mean(if_p_old, na.rm = TRUE)
  ) %>% 
  { t.test(.$if_p_new, .$if_p_old, paired = TRUE) }

# @todo check if stage 2 is any different
  
data %>%
  # filter(id <= 36) %>% 
  filter(ttype == "similar") %>% 
  filter(prec_ttype == "old" | prec_ttype == "new") %>% 
  mutate(
    if_p_new = if_else(prec_ttype == "new", accuracy, NULL),
    if_p_old = if_else(prec_ttype == "old", accuracy, NULL)
  ) %>% 
  group_by(id) %>% 
  summarise(
    if_p_new = mean(if_p_new, na.rm = TRUE),
    if_p_old = mean(if_p_old, na.rm = TRUE)
  ) %>% 
  { t.test(.$if_p_new, .$if_p_old, paired = TRUE) }

transformed <- data %>%
  # filter(id <= 36) %>% 
  filter(ttype == "similar") %>% 
  filter(prec_ttype == "old" | prec_ttype == "new") %>% 
  mutate(
    if_p_new = if_else(prec_ttype == "new", accuracy, NULL),
    if_p_old = if_else(prec_ttype == "old", accuracy, NULL)
  ) %>% 
  group_by(id) %>% 
  summarise(
    if_p_new = mean(if_p_new, na.rm = TRUE),
    if_p_old = mean(if_p_old, na.rm = TRUE)
  ) %>% 
  mutate(
    y = if_p_new - if_p_old,
    x = 1
  )

transformed %>% 
  lm(y ~ x, data = .) %>% 
  summary()


library(caret)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(y ~ x, data = transformed, trControl = cvControl, method = "lm", na.action = na.omit)

print(fit1)
summary(fit1)
