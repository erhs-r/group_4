library(tidyverse)
library(dplyr)
library(magrittr)
library(forcats)
library(ggplot2)
library(ggthemes)
library(readr)
library(lubridate)

# Read in county case/deaths NY times data

counties <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv") %>%
  filter(state == "Colorado")

# use lag() to change values from total # of cases/deaths to daily new cases/deaths:

county_new <- counties %>%
  group_by(county) %>%
  arrange(date) %>%
  mutate(new_cases = cases - lag(cases, default = first(cases))) %>%
  mutate(new_deaths = deaths - lag(deaths, default = first(deaths)))

# join with Elizabeth's county classification dataframe for use in epi graphs:
# Note: this is Elizabeth's code.

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

county_class <- full_join(county_new, county_bins, by = "county")

# consolidate data from county info to state info using aggregate():

co_cases <- aggregate(county_new["new_cases"], by = county_new["date"], sum)
co_deaths <- aggregate(county_new["new_deaths"], by = county_new["date"], sum)

# Read in hospitalization data for CO:

getwd()
hosp_data <- read_csv("data/covid19_hospital_data_2020-11-29.csv")

# filter hospital data down to current hospitalization of confirmed covid cases. 

hosp_data_conf <- hosp_data %>%
  filter(description == "Currently Hospitalized" & metric == "Confirmed COVID-19")

# join dataframes (automatically joins by date for "full_join()")

co_cases_deaths <- full_join(co_cases, co_deaths)
co_full <- inner_join(co_cases_deaths, hosp_data_conf, by = "date") %>%
  select(1, 2, 3, 9) %>%
  rename(new_hospitalizations = "value")

#Plot of cases v deaths v hospitalizations (using aggregated datasets)

g4_epi_plot_1 <- co_full %>%
  ggplot() +
  geom_line(aes(x = date, y = new_cases, color = "new_cases")) +
  geom_line(aes(x = date, y = new_deaths, color = "new_deaths")) +
  geom_line(aes(x = date, y = new_hospitalizations, color = "new_hospitalizations")) +
  geom_vline(aes(xintercept = ymd("2020-07-04")), linetype = "dashed",
             alpha = 0.5) +
  geom_vline(aes(xintercept = ymd("2020-10-31")), linetype = "dashed",
             alpha = 0.5) +
  geom_text(aes(x = ymd("2020-07-04"), label="Fourth of July", y=4000), color = "grey36",
            hjust = 1.1) +
  geom_text(aes(x = ymd("2020-10-31"), label="Halloween", y=5000), color = "grey36",
            hjust = 1.1) +
  labs(x = "Date", y = "Cases, Deaths, and Hospitalizations", color = "Legend") +
  theme_classic() 

#Plot of total recorded cases by county (use county_class data so you can color by class)
#color by population category instead of by county to match Elizabeth's graphs. 

g4_epi_plot_2 <- county_class %>%
  na.omit %>%
  ggplot() +
  geom_line(aes(x = date, y = cases, group = county, col = class)) +
  labs(x = "Date", y = "Total Cases") +
  theme_classic()

# wrap plot in ggplotly() to animate:

library(plotly)
library(htmlwidgets)

g4_epi_plot_2_anm <- ggplotly(g4_epi_plot_2)
g4_epi_plot_2_anm

#Plot of rate per 10000 by county (note this only works if loading initial chunks of code 
#and assigning all objects in flexdashboard)

county_class_rates <- county_class %>%
  mutate(rate_per_100000 = new_cases/100000) %>% 
  filter(county == c("Lincoln", "Bent", "Kit Carson", "La Plata", "Logan", 
                     "Crowley", "El Paso", "Weld", "Larimer"))
#Lincoln, Bent, Kit Carson
#La Plata, Logan, Crowley
#El Paso, Weld, Larimer

g4_epi_plot_3 <- county_class_rates %>%
  na.omit() %>%
  ggplot() +
  geom_line(aes(x = date, y = rate_per_100000, group = county, col = class)) +
  labs(x = "Date", y = "Rate per 100000") +
  theme_classic()

g4_epi_plot_3_anm <- ggplotly(g4_epi_plot_3)

g4_epi_plot_3_anm








# These chunks are code to create a dataframe I didn't end up using:

#hosp_data_2 <- hosp_data %>%
#  filter(metric == "ICU Hospital Beds in Use" | metric == "Acute Care Hospital Beds in Use") %>%
#  select(5:7) %>%
#  mutate(value = as.numeric(value))

#hosp_data_beds <- hosp_data_icu %>%
#  group_by(metric) %>%
#  mutate(row = row_number()) %>% #create unique row numbers to avoid duplicates when pivoting
#  pivot_wider(names_from = metric, values_from = value) %>%
#  rename(icu_beds = "ICU Hospital Beds in Use", 
#         act_care_beds = "Acute Care Hospital Beds in Use") %>%
#  mutate(total_beds = icu_beds + act_care_beds)

