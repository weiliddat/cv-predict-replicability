library(haven)
library(dplyr)
library(caret)
library(zoo)

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

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

set.seed(1)

fit1 <- train(rt_rel - rt_unr ~ 1, data = transformed, trControl = cvControl, method = "lm")

print(fit1)
summary(fit1)
