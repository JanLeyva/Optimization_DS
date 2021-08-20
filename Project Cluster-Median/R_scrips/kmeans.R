# Assignment 1 ------------------------------------------------------------

#Cluster-median assignment
#Jan Leyva and Andreu Meca
#K-Means Clustering


# libraries ---------------------------------------------------------------

library(tidyverse)
library(scales)


# setting seed ------------------------------------------------------------

set.seed(2020)


# load data ---------------------------------------------------------------

#pv dataset
data <- read_delim("PV_data.csv", ";", 
                   escape_double = FALSE, trim_ws = TRUE) %>% 
  rename(lon = LONGITUD,
         lat = LATITUD) %>% 
  select(-c(X1))

#income dataset
data <- read_csv("2017_rendatributariamitjanaperpersona.csv")
barris <- read_csv("barris.csv")
euclidean_income <- read_csv("euclidean_income.csv")

#country dataset
data <- read_csv("Country-data.csv") %>% 
  column_to_rownames(var = "country")

# data wrangling ----------------------------------------------------------

#income dataset
data <- data %>% 
  left_join(barris, by = "Nom_Barri")
data <- data %>% 
  select(c("Import_Euros", "lat", "lon")) %>% 
  group_by(lat, lon) %>% 
  summarise(renda = mean(Import_Euros))

euclidean <- round(euclidean_income, 4)


# modelling ---------------------------------------------------------------

k_vec <- data.frame("k" = 1:10, "error" = NA)
for(i in c(1:10)){
  km_res <- kmeans(data, i, n = 25) #i = num. of clusters, n = num. initial random assignations
  k_vec$error[i] <- km_res$tot.withinss
}


# plot errors -------------------------------------------------------------

cluster_error <- ggplot(k_vec, mapping = aes(k, error/10e7)) +
  geom_point(colour = "#00BFC4", size = 2) +
  geom_line(colour = "#00BFC4") +
  labs(title = "Error per Number of Clusters k",
       x = "Number of clusters k",
       y = "Total Within Sum of Square") +
  scale_x_continuous(breaks = pretty_breaks()) +
  theme_bw()



# k means -----------------------------------------------------------------

km_res <- kmeans(data, 2, n = 25)

#time
start_time <- Sys.time()
means(data, 4, n = 25)
end_time <- Sys.time()
end_time - start_time

# plot clusters ------------------------------------------------------------

data_final <- data
data_final$cluster <- km_res$cluster
data_plot <- data_final %>% 
  mutate(cluster = factor(cluster, levels = c("1", "2", "4", "3")))

#punts verds dataset
kmeans <- ggplot(data_plot) +
  geom_point(mapping = aes(lat, lon, color = cluster), show.legend = FALSE) +
  labs(title = "Punts Verds by Coordinates in Barcelona",
       x = "Latitude",
       y = "Longitude") +
  theme_bw() 

#income dataset
ggplot(data_plot) +
  geom_point(mapping = aes(lat, lon, color = cluster)) +
  labs(title = "Average Tax Income by Coordinates in Barcelona. K-Means",
       x = "Latitude",
       y = "Longitude") +
  scale_color_discrete(name = "Cluster by income", 
                       labels = (c("7,7k - 12,3k",
                                  "12,4k - 16,3k",
                                  "16,8k - 21,87k",
                                  "24,3k - 28,2k"))) +
  theme_bw() 
 

