##########----------##########----------##########----------##########----------

##########---------- HEADER

##### meta-information
## Author: Hardika Dayalani (dayalani@rand.org)
## Creation: 2020-02-25 for Research Poster Presentation 
## Description: Creates a geocoded dataframe of cities that are either large or
  ## growing fast for mapping

##### environment set up
remove( list= objects() )

##### Load Libraries
library(readxl)
library(tidygeocoder)

##### Read in data
## Cities Population in 2018
cities <- readxl::read_excel("./Data/AnnualPopUrbanAggl-20200214054839.xlsx", sheet = "Data", skip = 6)
## Cities Growth in 2018
growth <- readxl::read_excel("./Data/AverageAnnualRateChangeUrbanAggl-20200214055849.xlsx", sheet = "Data", skip = 6)


##### Clean Data
## Drop extra columns
cities <- cities[, c(2, 4)]
## Clean names
names(cities) <- c("city_name", "pop")

## Drop extra columns
growth <- growth[, c(2, 4)]
## Clean names
names(growth) <- c("city_name", "rate")

##### Reshape Data
## Merge City Population & growth rate
cities <- merge(x = cities, y = growth, by = "city_name")

rm(growth)

## Subset to Fast growing cities & big cities
cities <- cities[{cities$pop >= 1000 | cities$rate >= 5}, ]

## Create City size category
cities$mega <- cut(cities$pop, 
                   breaks = c(300, 1000, 10000, Inf), 
                   labels = c("300k+", "1m+", "10m+"))

## Create City growth Category
cities$fast <- cut(cities$rate, 
                   breaks = c(0, 2.5, 5, Inf),
                   labels = c("<2.5%", "2.5+%", "5+%"))

##### Geocode

## Clean name
cities[cities$city_name == "Ahmadabad","pop"] <- "Ahmedabad"

## Geocode
cities <- cities %>% tidygeocoder::geocode(city_name, method = "osm")

## Add missing geocodes manually
## Durg-Bhilainagar
cities[cities$city_name == "Durg-Bhilainagar", "lat"] <- mean(c(21.21, 21.19))
cities[cities$city_name == "Durg-Bhilainagar", "long"] <- mean(c(81.38,81.28))
## Salem
cities[cities$city_name == "Salem", "lat"] <- 11.65
cities[cities$city_name == "Salem", "long"] <- 78.16
## Surat
cities[cities$city_name == "Surat", "lat"] <- 21.1702
cities[cities$city_name == "Surat", "long"] <- 72.831061

## save file
save(cities, file = "Cities.RData")