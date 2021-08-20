# Assignment 1 ------------------------------------------------------------

#Cluster-median assignment
#Jan Leyva and Andreu Meca
#Euclidean distance matrix


# function ----------------------------------------------------------------

euclidean <- function(nobs, nvars){
  #euclidean function
  euclidean <- data.frame(matrix(0, nrow = nobs, ncol = nobs, dimnames = list(1:nobs)))
  for(i in 1:nobs){
    names(euclidean)[i] <- i
    for(j in 1:nobs){
      for(k in 1:nvars){
        euclidean[i, j] <- euclidean[i, j] + (data[i, k] - data[j, k])^2
      }
      euclidean[i, j] <- sqrt(euclidean[i, j])
    }
  }
  return(euclidean)
}


# load data ---------------------------------------------------------------

#punts verds dataset
data <- read_delim("PV_data.csv", ";", 
                   escape_double = FALSE, trim_ws = TRUE) %>% 
  rename(Longitude = LONGITUD,
         Latitude = LATITUD) %>% 
  select(-c(X1))

#income dataset
data <- read_csv("2017_rendatributariamitjanaperpersona.csv")
barris <- read_csv("barris.csv")

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


# euclidean matrix --------------------------------------------------------

#income dataset
nobs <- nrow(data)
nvars <- length(data)

#euclidean punts verds
euclidean_pv <- euclidean(nobs, nvars)

#euclidean function income
euclidean_income <- euclidean(nobs, nvars)

#euclidean function country
euclidean_country <- euclidean(nobs, nvars)


# save matrix -------------------------------------------------------------

#punts verds dataset
write_csv(euclidean_pv, "euclidean_pv.csv")

#income dataset
write_csv(euclidean_income, "euclidean_income.csv")

#country dataset
write_csv(euclidean_country, "euclidean_country.csv")
