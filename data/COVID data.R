#put COVID Data here

library(tidyverse)

counties <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")

counties_CO <- counties %>% 
  filter(state == "Colorado")

head(counties_CO)

COhospitaldata <- read_csv("data/covid19_hospital_data_2020-11-29.csv")
