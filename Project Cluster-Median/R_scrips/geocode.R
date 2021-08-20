# Assignment 1 ------------------------------------------------------------

#Cluster-median assignment
#Jan leyva and Andreu Meca
#Reverse Geocoding

# libraries ---------------------------------------------------------------

library(tidyverse)
library(ggmap)

# google maps API ---------------------------------------------------------

register_google("AIzaSyCWTqE6gK737GSARxkHtFtD5ODAZxt6M28")


# load data ---------------------------------------------------------------

barris <- read_csv("2017_rendatributariamitjanaperpersona.csv")


# data wrangling ----------------------------------------------------------

barris <- barris %>% 
  select("Nom_Barri") %>% 
  mutate(dup = duplicated(.),
         Nom_Barri = paste(Nom_Barri, "Barcelona", sep = " ")) %>% 
  filter(dup == FALSE) %>% 
  select(-dup)


# reverse geocode ---------------------------------------------------------

barris <- mutate_geocode(barris, Nom_Barri)


# clean data --------------------------------------------------------------

barris <- barris %>% 
  mutate(Nom_Barri = substr(Nom_Barri, start = 1, stop = nchar(Nom_Barri)-10))

#fix Navas as it gives incorrect value
#Check https://latitude.to/articles-by-country/es/spain/237682/navas-barcelona-metro

barris$lon[which(barris$Nom_Barri == "Navas")] <- 2.185499
barris$lat[which(barris$Nom_Barri == "Navas")] <- 41.409331


# save data ---------------------------------------------------------------

#write_csv(barris, "barris.csv")
