# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html

library(ncdf4)
library(terra)

# install.packages("name_of_the_package_here")

setwd("~/Downloads") # in Windows '\' means '/'

soilm2023 <- rast("c_gls_SSM1km_202311250000_CEURO_S1CSAR_V1.2.1.nc") # the data concerns soil moisture in November 2023
plot(soilm2023)

# There are two elements, let's use the first one!
plot(soilm2023[[1]])

cl <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(soilm2023[[1]], col = cl)

### Cropping the dataset ###

ext <- c(22, 26, 55, 57) # the parameters are in the following order: minimal longitude, maximal longitude, minimal latitude, maximal latitude
soilm2023c <- crop(soilm2023, ext) # crops the dataset to the extent specified by the ext array and stores the cropped dataset in a new variable

plot(soilm2023c[[1]], col = cl)

### Same exercise with a new image ###

soilm2023_24 <- rast("c_gls_SSM1km_202311240000_CEURO_S1CSAR_V1.2.1.nc")
plot(soilm2023_24)
soilm2023_24c <- crop(soilm2023_24, ext)
plot(soilm2023_24c[[1]], col = cl)
