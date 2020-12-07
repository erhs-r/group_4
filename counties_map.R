library(tidyverse)
library(tigris)
library(viridis)
library(ggthemes)

co_counties <- counties(state = 08) %>% #read in SF files for counties
  rename(county = NAME)

cdphe <- read_csv("Data/CDPHE_COVID19_County-Level_Open_Data_Repository.csv") %>% #CDPHE data for rates
  rename(county = LABEL)

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

rate_map <- full_join(co_counties, cdphe, by = "county") %>% #join cdphe data to SF
  filter(Date == "11/11/2020") %>% #filter for Nov 11th
  filter(Metric == "Rate Per 100,000") #filter for rate

cdphe_class <- full_join(rate_map, county_bins, by = "county")

# ggplot() + #covid map by raw cases
#  geom_sf(data = co_counties) +
#  geom_sf(data = covid_map, aes(fill = cases)) +
#  scale_fill_viridis()

ggplot() + #covid map by rates 
  geom_sf(data = co_counties) +
  geom_sf(data = cdphe_class, aes(fill = Rate)) +
  facet_wrap(~class) +
  scale_fill_viridis() +
  theme_map()















