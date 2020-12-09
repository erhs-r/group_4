library(tidyverse)

counties <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv") %>%
  filter(state == "Colorado")

## Dashboard:  
## Map of CO
## Map of CO counties (cases by county)
## Get population data and look at cases by population 
## Epi curves, adding reference lines for 4th of July, Halloween, Thanksgiving 
## Overlay hospitalizations on the epi curve.

## use lag() function for get new cases instead of cumulative cases. group_by, mutate(new_cases = cases - lag(cases))

## specify in text where each dataset comes from in the text (even if they're merged).

## use package tidycensus to get census api and pull population data

## county boundaries from tigris 
