library(tidyverse)
library(tigris)
library(viridis)
library(ggthemes)
library(plotly)

co_counties <- counties(state = 08) %>% #read in SF files for counties
  rename(county = NAME)

cdphe <- read_csv("Data/Colorado_COVID-19_Positive_Cases_and_Rates_of_Infection_by_County_of_Identification.csv") %>% #CDPHE data for rates
  rename(county = LABEL) %>%
  slice(1:64)

covid <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv") %>%
  filter(state == "Colorado") #read in NYT covid data

covid_map <- full_join(co_counties, covid, by = "county") %>% #join NYT data to SF
  filter(date == "2020-12-01") #filter for 12-01-2020

county_bins <- tibble(county = c("Larimer", "Mesa", "Weld", "Boulder",
                                 "Broomfield", "Gilpin", "Adams",
                                 "Clear Creek", "Denver", "Arapahoe",
                                 "Jefferson", "Douglas", "Elbert", "Park",
                                 "Teller", "El Paso", "Pueblo",
                                 "Logan", "Phillips", "Morgan", "Prowers", "Crowley",
                                 "Otero", "Grand", "Routt", "Eagle", "Summit",
                                 "Garfield", "Pitkin", "Lake", "Chaffee",
                                 "Fremont", "Delta", "Montrose", "Ouray", "Alamosa",
                                 "Rio Grande", "Conejos", "Archuleta", "La Plata",
                                 "Montezuma","Moffat", "Rio Blanco", "Jackson", 
                                 "Gunnison","San Miguel", "Dolores", "San Juan",
                                 "Hinsdale","Mineral", "Saguache", "Custer", "Huerfano",
                                 "Costilla", "Las Animas", "Baca", "Bent",
                                 "Kiowa", "Lincoln", "Cheyenne", "Kit Carson",
                                 "Yuma", "Washington", "Sedgwick"),
                      class = c("urban","urban","urban","urban","urban","urban",
                                "urban","urban","urban","urban","urban","urban",
                                "urban","urban","urban","urban","urban", "rural",
                                "rural","rural","rural","rural","rural","rural",
                                "rural","rural","rural","rural","rural","rural",
                                "rural","rural","rural","rural","rural","rural",
                                "rural","rural","rural","rural","rural", 
                                "frontier","frontier","frontier","frontier",
                                "frontier","frontier","frontier","frontier",
                                "frontier","frontier","frontier","frontier",
                                "frontier","frontier","frontier","frontier",
                                "frontier","frontier","frontier","frontier",
                                "frontier","frontier","frontier"))

rate_map <- full_join(co_counties, cdphe, by = "county") #join cdphe data to SF

cdphe_class <- full_join(rate_map, county_bins, by = "county") %>%
  rename(rate = County_Rate_Per_100_000)

# ggplot() + #covid map by raw cases
#  geom_sf(data = co_counties) +
#  geom_sf(data = covid_map, aes(fill = cases)) +
#  scale_fill_viridis()

map <- ggplot() + #covid map by rates 
  geom_sf(data = co_counties) +
  geom_sf(data = cdphe_class, aes(fill = rate, group = county)) +
  facet_wrap(~class) +
  scale_fill_viridis() +
  theme_map() +
  theme(legend.position="bottom")

anmap <- ggplotly(map)
anmap

