#put COVID Data here

library(tidyverse)

counties <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")

counties_CO <- counties %>% 
  filter(state == "Colorado")

head(counties_CO)

