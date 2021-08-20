# Assignment 1 ------------------------------------------------------------

#Cluster-median assignment
#Jan Leyva and Andreu Meca
#Plot Cluster-median AMPL


# libraries ---------------------------------------------------------------

library(readxl)
library(tidyverse)


# load data ---------------------------------------------------------------

#green points
ampl <- read_excel("green_solution_ampl.xlsx") %>% 
  select(-c("...1"))
data <- read_delim("PV_data.csv", ";", 
                   escape_double = FALSE, trim_ws = TRUE) %>% 
  rename(lon = LONGITUD,
         lat = LATITUD) %>% 
  select(-c(X1))

#income
ampl <- read_excel("income_solution_ampl.xlsx") %>% 
  select(-c("...1"))
data <- read_csv("2017_rendatributariamitjanaperpersona.csv")
barris <- read_csv("barris.csv")

# data wrangling ----------------------------------------------------------

ind <- which(ampl == 1,arr.ind=TRUE)
ampl[ind] <- as.numeric(names(ampl)[ind[,"col"]])
ampl <- ampl %>% 
  mutate(cluster = rowSums(.[1:ncol(ampl)], na.rm = TRUE))

#green dataset
data$cluster <- ampl$cluster

#income dataset
data <- data %>% 
  left_join(barris, by = "Nom_Barri")
data <- data %>% 
  select(c("Import_Euros", "lat", "lon")) %>% 
  group_by(lat, lon) %>% 
  summarise(renda = mean(Import_Euros))
data$cluster <- ampl$cluster


# plot data ---------------------------------------------------------------

#green dataset
data_plot <- data %>% 
  mutate(cluster = factor(cluster))

ggplot(data_plot) +
  geom_point(mapping = aes(lat, lon, color = cluster), show.legend = FALSE) +
  labs(title = "Green Points by Coordinates in Barcelona",
       x = "Latitude",
       y = "Longitude") +
  theme_bw() 

#income dataset
data_plot <- data %>% 
  mutate(renda = renda/1000,
         cluster = factor(cluster, levels = c("41", "42", "39", "22")))

ggplot(data_plot) +
  geom_point(mapping = aes(lat, lon, color = cluster)) +
  labs(title = "Average Tax Income by Coordinates in Barcelona. Cluster-Median",
       x = "Latitude",
       y = "Longitude") +
  scale_color_discrete(name = "Cluster by income", 
                       labels = (c("7,7k - 11,9k",
                                   "12,1k - 16,3k",
                                   "16,8k - 21,87k",
                                   "24,3k - 28,2k"))) +
  theme_bw() 
