# A package is needed for point pattern analysis. Here is its description: https://cran.r-project.org/web/packages/spatstat/index.html
install.packages("spatstat") # this line is for installing the spatstat library into R
library(spatstat) # that one is for calling it for this paticular script

# We will use the bei dataset from the spatstat library. Description: "A point pattern giving the locations of 3605 trees in a tropical rain forest. Accompanied by covariate data giving the elevation (altitude) and slope of elevation in the study region." This description is given as "hover" text when you type "bei" in the console in R studio.

bei # loads the dataset
plot(bei, cex=.2, pch=19) # plots bei as a set of filled up points of size .2

bei.extra # loads the extra datasets attached to bei
plot(bei.extra)

plot(bei.extra$elev) # the '$' selects the elev part of the extra datasets
elevation <- bei.extra$elev
plot(elevation)

# Second method to select elements:
elevation2 <- bei.extra[[1]] # the double parentheses are because bei.extra is a 2D dataset
plot(elevation2)

# Passing from points to a continuous surface:
densitymap <- density(bei) # apparently, the density() function "computes kernel density estimates". I don't know what this means
plot(densitymap)
points(bei, cex=.2)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100) # description: "These functions return functions that interpolate a set of given colors to create new color palettes (like topo.colors) and color ramps, functions that map the interval [0, 1] to colors (like grey)." Basically, it creates the color palette
plot(densitymap, col = cl) # plots densitymap with the palette we just created

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(4) # changes the number of intermediate colors between each of the colors in the array
plot(densitymap, col=cl)

clnew <- colorRampPalette(c("dark blue", "blue", "light blue"))(100) # changes the colors in the palette
plot(densitymap, col=clnew)

elev <- elevation # renaming "elevation" because we're lazy ^^

# Building a multiframe:
par(mfrow = c(1,2))
plot(densitymap)
plot(elev)

par(mfrow=c(2,1))
plot(densitymap)
plot(elev)

par(mfrow=c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
