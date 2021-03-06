#put COVID Data here

##Hospital data goes to 11/29/2020

library(tidyverse)

counties <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")

counties_CO <- counties %>% 
  filter(state == "Colorado")

head(counties_CO)


COhospitaldata <- read_csv("data/covid19_hospital_data_2020-11-29.csv")


#CDPHE data to get population numbers and rates

cdphe <- read_csv("Data/CDPHE_COVID19_County-Level_Open_Data_Repository.csv")


#Comments from Brooke
#group_by counties
#mutate and use lag
##We have to subtract previous cases from the current day
#US census (tidycensus) has population data

#county boundries in tigris


