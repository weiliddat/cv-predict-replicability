library(haven)
library(dplyr)
library(caret)
library(tidyr)

data <- read.csv("Kovacs et al (2010) - Data2.csv")

data %>% 
  mutate(rtp0a0 = mean_p0a1 - 18160, rtp0a1 = mean_p0a0 - 18160) %>% 
  lm(rtp0a1 - rtp0a0 ~ 1, data = .) %>% 
  summary()

### CV

transformed2 <- data %>%
  mutate(rtp0a0 = mean_p0a1 - 18160, rtp0a1 = mean_p0a0 - 18160) %>%
  gather(rtp0a0, rtp0a1, key = "treatment", value = "rt")

data$rtp0a0 <- data$mean_p0a0 - 18160   
data$rtp0a1 <- data$mean_p0a1 - 18160   
t.test(data$rtp0a0, data$rtp0a1, paired = TRUE)

cvControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5
)

cvFit <- train(rt ~ treatment, data = transformed2, trControl = cvControl, method = "lm", na.action = na.omit)
cvFit

summary(cvFit)

###

# excluded = c(16, 25, 46, 69, 85)
# 
# data %>% 
#   mutate(rtp0a0 = p0a0 - 18160, rtp0a1 = p0a1 - 18160) %>% 
#   group_by(participant) %>%
#   summarise(
#     p0a0 = mean(p0a0),
#     p0a1 = mean(p0a1),
#     rtp0a0 = mean(rtp0a0),
#     rtp0a1 = mean(rtp0a1)
#   ) %>% 
#   filter(!participant %in% excluded) %>% 
#   lm(rtp0a0 ~ rtp0a1, data = .) %>% 
#   summary()
