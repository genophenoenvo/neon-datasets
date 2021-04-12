###########Read in libraries###########
# devtools::install_github('eco4cast/neon4cast')
# install.packages('readr')
library(neon4cast)
library(readr)
library(dplyr)

###########Download weather data###########
pheno_sites <- c("HARV", "BART", "SCBI", "STEI", "UKFS", "GRSM", "DELA", "CLBJ")
download_noaa(pheno_sites)
noaa_fc <- stack_noaa()

###########Clean up weather data###########
forecast_weather <- noaa_fc %>% 
  mutate(date_time = as.Date(substr(startDate, 1, 10)) + lubridate::hours(time))

###########Save weather csv###########
write_csv(forecast_weather, file = paste0('pheno_images/NOAA_GEFS_35d_', Sys.Date(), '.csv'))
