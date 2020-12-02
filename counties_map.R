install.packages("tidycensus")

library(tidycensus)
library(tidyverse)
library(tigris)
library(viridis)

co_counties <- counties(state = 08) %>% #read in SF files for counties
  rename(county = NAME)

covid <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv") %>%
  filter(state == "Colorado") #read in NYT covid data

covid_map <- full_join(co_counties, covid, by = "county") %>% #join NYT data to SF
  filter(date == "2020-12-01") #filter for 12-01-2020

ggplot() + #covid map
  geom_sf(data = co_counties) +
  geom_sf(data = covid_map, aes(fill = cases)) +
  scale_fill_viridis()



