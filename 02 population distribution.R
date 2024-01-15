# Why do populations disperse over the landscape in a certain manner? 
# To answer this question, we will use two libraries: sdm and terra. 
# Their documentations can be found at https://cran.r-project.org/web/packages/sdm/index.html and https://cran.r-project.org/web/packages/terra/index.html respectively. 
# sdm is a framework for developping species distribution models, and terra contains methods for spatial data analysis with vector and raster data

library(sdm) 
library(terra)

file <- system.file("external/species.shp", package = "sdm") # the system.file() function takes two arguments: the pathway inside the package directory to the file we want to use, and the package we're using. It returns the whole path to the desired file in the computer
rana <- vect(file) # the vect() function maked the file into a usable object
plot(rana)

### Selecting presences ###

pres <- rana[rana$Occurrence == 1,] # "rana[rana$Occurrence == 1,]" selects the points within rana for which the Occurence attribute equals 1. The coma signals the end of the query and is optional
plot(pres)

### Exercise: select absences and call them abse ###

abse <- rana[rana$Occurrence==0,]
plot(abse)

### Exercise: plot presences and absences, one beside the other ###
par(mfrow=c(1,2))
plot(pres)
plot(abse)

# Your new friend in case of graphical nulling:
dev.off() # this closes all plots

### Exercise: plot pres and abse altogether with two different colours ###

plot(pres, col = "dark blue")
points(abse, col = "light blue") # this function draws the data as points in the previous plot

### Predictors: environmental variables ###

# Elevation predictor #
elev <- system.file("external/elevation.asc", package = "sdm") 
elevmap <- rast(elev) # the rast() function is from terra package. Description: "Returns the x and y coordinates of each pixel in a pixel image or binary mask."
plot(elevmap)
points(pres, cex = .5)

# Temperature predictor #
temp <- system.file("external/temperature.asc", package = "sdm") 
tempmap <- rast(temp)
plot(tempmap)
points(pres, cex = .5)

### Exercise: do the same with vegetation cover ###

vege <- system.file("external/vegetation.asc", package = "sdm") 
vegemap <- rast(vege)
plot(vegemap)
points(pres, cex = .5)

### Exercise: do the same with vegetation cover ###

prec <- system.file("external/precipitation.asc", package = "sdm") 
precmap <- rast(prec)
plot(precmap)
points(pres, cex = .5)

### Building the final multiframe ###

par(mfrow = c(2,2))

# elev #
plot(elevmap)
points(pres, cex = .5)

# temp #
plot(tempmap)
points(pres, cex = .5)

# vege #
plot(vegemap)
points(pres, cex = .5)

# prec #
plot(precmap)
points(pres, cex = .5)
