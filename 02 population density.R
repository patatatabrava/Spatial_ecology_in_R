# A package is needed for point pattern analysis. Here is its documentation: https://cran.r-project.org/web/packages/spatstat/index.html
install.packages("spatstat") # this line is for installing the spatstat library into R
library(spatstat) # that one is for calling it for this particular script

# We will use the bei dataset from the spatstat library. 
# Description: "A point pattern giving the locations of 3605 trees in a tropical rain forest. Accompanied by covariate data giving the elevation (altitude) and slope of elevation in the study region." 
# This description is given as "hover" text when you type "bei" in the console in R studio.

bei # loads the dataset, but this line doesn't seem to be necessary for what follows. This is not the standard way to load a dataset. According to the documentation "datasets in spatstat are lazy-loaded, so you can simply type the name of the dataset to use it; there is no need to type data(amacrine) etc."

plot(bei, cex = .2, pch = 19) # plots bei as a set of solid circles of size .2

bei.extra # loads the extra data related to bei
plot(bei.extra)

### Selecting a variable in the dataset ###

plot(bei.extra$elev) # the '$' selects the elev variable in the extra data
elevation <- bei.extra$elev
plot(elevation)

# Second method #
elevation2 <- bei.extra[[1]] # the double parentheses are because bei.extra is a 2D dataset
plot(elevation2)

### Passing from points to a continuous surface ###

densitymap <- density(bei) # apparently, the density() function "computes kernel density estimates". I don't know what this means, but I do know we're using it to build a density map
plot(densitymap)
points(bei, cex=.2)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100) # creates the color palette. Full description: "These functions return functions that interpolate a set of given colors to create new color palettes (like topo.colors) and color ramps, functions that map the interval [0, 1] to colors (like grey)." 

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(4) # changes the number of intermediate colors between each of the colors in the array
plot(densitymap, col=cl)

clnew <- colorRampPalette(c("dark blue", "blue", "light blue"))(100) # changes the colors in the palette
plot(densitymap, col=clnew)

elev <- elevation # renaming "elevation" because we're lazy ^^

### Building a multiframe ###

par(mfrow = c(1,2)) # creates a multiframe with 1 line and 2 columns. Description of the par function: "par can be used to set or query graphical parameters. Parameters can be set by specifying them as arguments to par in tag = value form, or by passing them as a list of tagged values." Here, we're setting the mfrow parameter

### Plotting densitymap and elev in the multiframe ###

plot(densitymap)
plot(elev)
# The first plot appears on the left

par(mfrow = c(2,1)) # creates a multiframe with 2 lines and 1 column.
plot(densitymap)
plot(elev)
# The first plot appears on top

# Plots in a multiframe go from left to right and from top to bottom

par(mfrow = c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
