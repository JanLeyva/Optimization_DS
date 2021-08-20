# Assignment 1 ------------------------------------------------------------

#Cluster-median assignment
#Jan Leyva and Andreu Meca
#K-Means Clustering


# libraries ---------------------------------------------------------------

library(tidyverse)
library(genieclust)
library(ggpubr)


# setting seed ------------------------------------------------------------

set.seed(2020)


# load data ---------------------------------------------------------------

#pv dataset
data <- read_delim("PV_data.csv", ";", 
                   escape_double = FALSE, trim_ws = TRUE) %>% 
  rename(lon = LONGITUD,
         lat = LATITUD) %>% 
  select(-c(X1))

#income
euclidean_income <- read_csv("euclidean_income.csv")
data <- read_csv("data_income_clean.csv")

#country
euclidean_country <- read_csv("euclidean_country.csv")
data <- read_csv("Country-data.csv") %>% 
  column_to_rownames(var = "country")

# minimum spanning tree ---------------------------------------------------

mst <- gclust(data)
cluster <- cutree(mst, k = 2)

#time
start_time <- Sys.time()
gclust(data)
cutree(mst, k = 4)
end_time <- Sys.time()
end_time - start_time


# plot clusters -----------------------------------------------------------

#pv dataset
mst_plot <- data %>% 
  cbind(cluster) %>% 
  mutate(cluster = factor(cluster, levels = c("1", "2", "4", "3")))

#income dataset
mst_plot <- data %>% 
  cbind(cluster) %>% 
  mutate(renda = renda/1000,
         cluster = factor(cluster, levels = c("1", "2", "3", "4")))

#pv dataset
ggplot(mst_plot) +
  geom_point(mapping = aes(lat, lon, color = cluster), show.legend = FALSE) +
  labs(title = "Punts Verds by Coordinates in Barcelona",
       x = "Latitude",
       y = "Longitude") +
  theme_bw() 


#income dataset
ggplot(mst_plot) +
  geom_point(mapping = aes(lat, lon, color = cluster)) +
  labs(title = "Average Tax Income by Coordinates in Barcelona. Minimum Spanning Tree Heuristic",
       x = "Latitude",
       y = "Longitude") +
  scale_color_discrete(name = "Cluster by income", 
                       labels = (c("7,7k - 10,48k",
                                   "12,95k - 12,7k",
                                   "13k - 16,82k",
                                   "17,54k - 28,2k"))) +
  theme_bw() 
