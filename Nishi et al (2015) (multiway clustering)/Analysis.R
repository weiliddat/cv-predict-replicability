library(readr)
library(dplyr)
library(caret)

data <- read_csv("Nishi et al (2015) - Session Data (Replication).csv")

data %>% filter(showScore == TRUE)

