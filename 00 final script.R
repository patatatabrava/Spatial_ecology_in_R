# Final script including all the different scripts during lectures

#--------------------

# Summary:
# 01 Beginning
# 02.1 Population density
# 02.2 Population distribution
# 03.1 Community multivariate analysis
# 03.2 Community overlap
# 04 Remote sensing data visualisation
# 05 Spectral indices
# 06 Time series
# 07 External data
# 08 Copernicus data
# 09 Classification
# 10 Variability
# 11 Principal Component Analysis

#--------------------

# 01 Beginning

### Using R as a calculator ###

2 + 3
# You don't have to use "print" to visualize the output of a function. It automatically appears in the console, right after the line of code in which you called the function (at least in R studio)

# This is the way you assign a value to an object:
zima <- 2 + 3
zima # shows the value contained in zima

duccio <- 5 + 3
duccio

final <- zima * duccio # this is the syntax for multiplying 2 numbers together
final

final^2 # this is the syntax for taking exponents

### Making arrays and plots ###

# The c() function is used to make arrays. It forces all its arguments into a common type and its output is of the same type. "c" stands for "concatenate"
# Examples:
microplastics <- c(10, 20, 30, 50, 70) 
people <- c(100, 500, 600, 1000, 2000)

plot(people, microplastics) # shows the number of microplastics as a function of the number of people, without labelling the axes. You don't need to import a library to make plots, unlike in Python

plot(people, microplastics, xlab = "number of people", ylab = "microplastics") # makes the same plot with labels on the axes

plot(people, microplastics, pch = 19) # "pch = 19" selects point shape 19 (see tables on the interwebz)
# Link to such tables: https://www.google.com/search?client=ubuntu-sn&hs=yV6&sca_esv=570352775&channel=fs&sxsrf=AM9HkKknoSOcu32qjoErsqX4O1ILBOJX4w:1696347741672&q=point+symbols+in+R&tbm=isch&source=lnms&sa=X&ved=2ahUKEwia9brkm9qBAxVrQvEDHbEYDuMQ0pQJegQIChAB&biw=1760&bih=887&dpr=1.09#imgrc=lUw3nrgRKV8ynM

plot(people, microplastics, pch = 19, cex = 2) # "cex" stands for "character exageration", it chooses the size of the points
plot(people, microplastics, pch = 19, cex = 2, col = "blue") # "col = "blue"" is pretty self-explanatory

#--------------------

# 02.1 Population density

# A package is needed for point pattern analysis. Here is its documentation: https://cran.r-project.org/web/packages/spatstat/index.html

install.packages("spatstat") # this line is for installing the spatstat library into R
library(spatstat) # that one is for calling it for this particular script

# We will use the bei dataset from the spatstat library. 
# Description: "A point pattern giving the locations of 3605 trees in a tropical rain forest. Accompanied by covariate data giving the elevation (altitude) and slope of elevation in the study region." 
# This description is given as "hover text" when you type "bei" in the console in R studio

bei # loads the dataset, but this line doesn't seem to be necessary for what follows
# This is not the standard way to load a dataset. According to the documentation "datasets in spatstat are lazy-loaded, so you can simply type the name of the dataset to use it; there is no need to type data(amacrine) etc."
plot(bei, cex = .2, pch = 19) # plots bei as a set of solid circles of size .2

bei.extra # loads the extra data related to bei
plot(bei.extra)

### Selecting a variable in the dataset ###

plot(bei.extra$elev) # the '$' symbol is used to select named item in a list, here the elev variable in the extra data
elevation <- bei.extra$elev
plot(elevation)

# Second method #

elevation2 <- bei.extra[[1]] # the double parentheses are because bei.extra is a 2D dataset
plot(elevation2)

# This method also works for unnamed items

### Passing from points to a continuous surface ###

densitymap <- density(bei) # apparently, the density() function "computes kernel density estimates". I don't know what this means, but I do know we're using it to build a density map
plot(densitymap)
points(bei, cex=.2)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100) # creates the color palette. Full description: "These functions return functions that interpolate a set of given colors to create new color palettes (like topo.colors) and color ramps, functions that map the interval [0, 1] to colors (like grey)." 

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(4) # changes the number of intermediate colors between each of the colors in the array
plot(densitymap, col=cl)

clnew <- colorRampPalette(c("dark blue", "blue", "light blue"))(100) # creates a palette with new colors
plot(densitymap, col=clnew)

elev <- elevation # renaming "elevation" because we're lazy ^^

### Building a multiframe ###

par(mfrow = c(1,2)) # creates a multiframe with 1 line and 2 columns. 
# Description of the par function: "par can be used to set or query graphical parameters. Parameters can be set by specifying them as arguments to par in tag = value form, or by passing them as a list of tagged values." Here, we're setting the mfrow parameter

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

#--------------------

# 02.2 Population distribution

# Why do populations disperse over the landscape in a certain manner? 
# To answer this question, we will use two libraries: sdm and terra. 
# Their documentations can be found at https://cran.r-project.org/web/packages/sdm/index.html and https://cran.r-project.org/web/packages/terra/index.html respectively. 
# sdm is a framework for developping species distribution models, and terra contains methods for spatial data analysis with vector and raster data

library(sdm) 
library(terra)

file <- system.file("external/species.shp", package = "sdm") # the system.file() function takes two arguments: the pathway inside the package directory to the file we want to use, and the package we're using. It returns the whole path to the desired file in the computer
rana <- vect(file) # the vect() function makes the file into a usable object
plot(rana)

### Selecting presences ###

pres <- rana[rana$Occurrence == 1,] # "rana[rana$Occurrence == 1,]" selects the points within rana for which the Occurence variable equals 1. The coma signals the end of the query and is optional
plot(pres)

### Exercise: select absences and call them abse ###

abse <- rana[rana$Occurrence == 0,]
plot(abse)

### Exercise: plot presences and absences, one beside the other ###
par(mfrow=c(1,2))
plot(pres)
plot(abse)

# Your new friend in case of graphical nulling:
dev.off() # this closes all plots. "dev" stands for "devices"

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

#--------------------

# 03.1 Community multivariate analysis

library(vegan)

data(dune)
head(dune)

ord <- decorana(dune)

ldc1 =  3.7004 
ldc2 =  3.1166 
ldc3 = 1.30055
ldc4 = 1.47888

total = ldc1 + ldc2 + ldc3 + ldc4

pldc1 = ldc1 * 100 / total
pldc2 = ldc2 * 100 / total
pldc3 = ldc3 * 100 / total
pldc4 = ldc4 * 100 / total

pldc1
pldc2

pldc1 + pldc2

plot(ord) 

#--------------------

# 03.2 Community overlap

# We will use a library for community ecology called vegan. Link to its documentation: https://cran.r-project.org/web/packages/vegan/

library(vegan)

data(dune) # loads the dune dataset. It concerns vegetation and environment in Dutch dune meadows (see documentation). The data() function is the standard way of loading data
head(dune) # returns the start of the dataset

ord <- decorana(dune) # description of the decorana() function: "Performs detrended correspondence analysis (DCA) and basic reciprocal averaging or orthogonal correspondence analysis." 
# DCA is a multivariate statistical method used in ecology to analyze and visualize species composition data

#### Storing the lengths of the first 4 axes of the DCA in 4 variables ###

ldc1 = 3.7004
ldc2 = 3.1166 
ldc3 = 1.30055
ldc4 = 1.47888

# We can use "=" instead of "<-" because we're manipulating numbers

### Calculating the contribution of each axis to the total axis length (as a percentage) ###

total = ldc1 + ldc2 + ldc3 + ldc4

pldc1 = ldc1 * 100 / total
pldc2 = ldc2 * 100 / total
pldc3 = ldc3 * 100 / total
pldc4 = ldc4 * 100 / total

### Displaying two of the contributions, their sum and the DCA of ord ###

pldc1
pldc2

pldc1 + pldc2

# Together, the first two axes contribute around 71.04% of the total variation in the data. The first axis contributes the most to it (38.56%)

plot(ord) 

#--------------------

# 04 Remote sensing data visualisation

# We will learn how to visualize remote sensing (satellite) data using the imageRy library
# It isn't on CRAN, but, instead, it can be found at: https://github.com/ducciorocchini/imageRy/tree/main
# Here is a short documentation on the functions: https://htmlpreview.github.io/?https://github.com/ducciorocchini/imageRy/blob/main/imageRy_rapid_manual.html
# The description of the datasets, on the other hand, is at: https://github.com/ducciorocchini/imageRy/blob/main/data_description.md

library(devtools) # this library allows us to install other libraries from GitHub
install_github("ducciorocchini/imageRy")  # this function, which is from devtools, installs the imageRy package from GitHub

library(imageRy)
library(terra)

im.list() # lists all the image files in imageRy

# Satellite data is organized in bands, which each correspond to a different part of the electromagnetic spectrum.
# The combination of these bands allows for the analysis of diverse surface features, including vegetation health, water bodies, urban areas

b2 <- im.import("sentinel.dolomites.b2.tif") # imports an image from the package and stores it in a variable called b2. This is the second band (ie. the blue band) of a picture of the Dolomites taken by the Sentinel-2 satellites

cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(b2, col = cl)

### Importing and plotting the green band from Sentinel-2 (band 3) ###

b3 <- im.import("sentinel.dolomites.b3.tif") 
plot(b3, col = cl)

### Importing and plotting the red band from Sentinel-2 (band 4) ###

b4 <- im.import("sentinel.dolomites.b4.tif") 
plot(b4, col = cl)

### Importing and plotting the NIR (near infra-red) band from Sentinel-2 (band 8) ###

b8 <- im.import("sentinel.dolomites.b8.tif") 
plot(b8, col = cl)

### Building a multiframe with all the plots ###

par(mfrow=c(2,2))
plot(b2, col = cl)
plot(b3, col = cl)
plot(b4, col = cl)
plot(b8, col = cl)

### Stacking the images ###

# "Stacking" means putting all the images in a single object, like in the following line:
stacksent <- c(b2, b3, b4, b8)
dev.off() # we close all the previous plots to get rid of the multiframe
plot(stacksent, col = cl)

plot(stacksent[[4]], col = cl) # plots only the NIR band using the stack

### Exercise: plot in a multiframe the bands with different color ramps ###

par(mfrow = c(2,2))
clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(b2, col = clb)
clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(b3, col = clg)
clr <- colorRampPalette(c("dark red", "red", "pink")) (100)
plot(b4, col = clr)
cln <- colorRampPalette(c("brown", "orange", "yellow")) (100)
plot(b8, col = cln)

### Plotting the same data in RGB space ###

# The bands are in the folling order in our stack: 
# band 2 (blue) element 1, stacksent[[1]] 
# band 3 (green) element 2, stacksent[[2]]
# band 4 (red) element 3, stacksent[[3]]
# band 8 (NIR) element 4, stacksent[[4]]

im.plotRGB(stacksent, r = 3, g = 2, b = 1) # plots the image with each color in its normal place
im.plotRGB(stacksent, r = 4, g = 3, b = 2) # plots the NIR on the red, the red on the green and the green on the blue, ie the NIR data appears red, the red data appears green and the green data appears blue in the image
im.plotRGB(stacksent, r = 3, g = 4, b = 2) # plots the red on the red, the NIR on the green and the green the blue
im.plotRGB(stacksent, r = 3, g = 2, b = 4) # plots the red on the red, the green on the green and the NIR the blue

pairs(stacksent) # creates a matrix of scatterplots. It shows the correlation between the different variables

#--------------------

# 05 Spectral indices

# We will calculate two vegetation indices: the DVI, for Difference Vegetation Index, and the NDVI, for Normalized Difference Vegetation Index. 
# They are indicators of the vegetation's health which it can be useful to monitor over time. 
# However, if the vegetation is unhealthy, field observation is often necessary to identify the cause 

library(imageRy)
library(terra)

im.list() # we want to know the name of the image we need to import, so we have a look at the list of all the data in imageRy

### Importing and plotting the old image of the Mato Grosso ###

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg") # imports the Landsat-5 image from 1992
# The bands are in the following order: 1 = NIR, 2 = red, 3 = green
im.plotRGB(m1992, r = 1, g = 2, b = 3)
im.plotRGB(m1992, 1, 2, 3) # different syntax for doing the same thing as in the previous line
im.plotRGB(m1992, r = 2, g = 1, b = 3) 
im.plotRGB(m1992, r = 2, g = 3, b = 1) # in this plot, the red is on the red, the green is on the green, and the NIR is on the blue. There is no blue in our file, so we can't make a normal RGB plot

# Interpretation: the NIR and the green are more abondant than the red, so the vegetation is healthy

### Importing and plotting the recent image of the Mato Grosso ###

m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg") # imports the ASTER image from 2006
im.plotRGB(m2006, r = 2, g = 3, b = 1)

# Interpretation: less NIR and green, so the vegetation is less healthy

### Building a multiframe with the 1992 and 2006 images ###

par(mfrow = c(1,2))
im.plotRGB(m1992, r = 2, g = 3, b = 1)
im.plotRGB(m2006, r = 2, g = 3, b = 1)

### Calculating and plotting the DVI for the old image ###

# The DVI is the difference between the NIR and red bands. The higher the NIR, the healthier the vegetation
# Recall that the bands are in the following order: 1 = NIR, 2 = red, 3 = green

dvi1992 = m1992[[1]] - m1992[[2]] # here, we (can) use "=" and not "<-" because we are making an operation
plot(dvi1992)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col = cl)

### Exercise: calculate the DVI for the new image ###

dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006, col = cl)

### Calculating and plotting the NDVI for the old image ###

# The NDVI is the ratio between the DVI and the sum of the NIR and red bands (ie the normalization of the DVI)
ndvi1992 = dvi1992 / (m1992[[1]] + m1992[[2]])
plot(ndvi1992, col = cl)

### Calculating and plotting the NDVI for the new image ###

ndvi2006 = dvi2006 / (m2006[[1]] + m2006[[2]])
plot(ndvi2006, col = cl)

### Making a multiframe with both plots ###

par(mfrow = c(1,2))
plot(ndvi1992, col = cl)
plot(ndvi2006, col = cl)

### Making another multiframe with a different color scheme and the same data ###

clvir <- colorRampPalette(c("violet", "dark blue", "blue", "green", "yellow"))(100) # makes a color palette with the same colors as in the viridis library. These are easy to read for colorblind people, who typically have a hard time distinguishing red and green
par(mfrow = c(1,2))
plot(ndvi1992, col = clvir)
plot(ndvi2006, col = clvir)

### Using a function from imageRy to speed up the calculation ###

ndvi2006a <- im.ndvi(m2006, 1, 2)
plot(ndvi2006a, col = cl)

#--------------------

# 06 Time series

# time series analysis

library(imageRy)
library(terra)

im.list()

# import the data
EN01 <- im.import("EN_01.png")
EN13 <- im.import("EN_13.png")

par(mfrow=c(2,1))
im.plotRGB.auto(EN01)
im.plotRGB.auto(EN13)

# using the first element (band) of images
dif = EN01[[1]] - EN13[[1]]

# palette
cldif <- colorRampPalette(c("blue", "white", "red")) (100)
plot(dif, col=cldif)


### New example: temperature in Greenland

g2000 <- im.import("greenland.2000.tif")
clg <- colorRampPalette(c("black", "blue", "white", "red")) (100)
plot(g2000, col=clg)

g2005 <- im.import("greenland.2005.tif")
g2010 <- im.import("greenland.2010.tif")
g2015 <- im.import("greenland.2015.tif")

plot(g2015, col=clg)

par(mfrow=c(1,2))
plot(g2000, col=clg)
plot(g2015, col=clg)

# stacking the data
stackg <- c(g2000, g2005, g2010, g2015)
plot(stackg, col=clg)

# Exercise: make the differencxe between the first and the final elemnts of the stack
difg <- stackg[[1]] - stackg[[4]]
# difg <- g2000 - g2015
plot(difg, col=cldif)

# Exercise: make a RGB plot using different years
im.plotRGB(stackg, r=1, g=2, b=3)

#--------------------

# 07 External data

# External data

library(terra)

# set the working directory based on your path:
# setwd("youtpath")
# W***** users: C:\\path\Downloads -> C://path/Downloads
# My own:
setwd("~/Downloads")
naja <- rast("najafiraq_etm_2003140_lrg.jpg")  # like in im.import()

plotRGB(naja, r=1, g=2, b=3) # im-plotRGB

# Exercise: Download the second image from the same site and import it in R
najaaug <- rast("najafiraq_oli_2023219_lrg.jpg")
plotRGB(najaaug, r=1, g=2, b=3)

par(mfrow=c(2,1))
plotRGB(naja, r=1, g=2, b=3) # im-plotRGB
plotRGB(najaaug, r=1, g=2, b=3)

# multitemporal change detection
najadif = naja[[1]] - najaaug[[1]] 
cl <- colorRampPalette(c("brown", "grey", "orange")) (100)
plot(najadif, col=cl)

# Download your own preferred image:
typhoon <- rast("mawar_vir2_2023144_lrg.jpg")

plotRGB(typhoon, r=1, g=2, b=3)
plotRGB(typhoon, r=2, g=1, b=3)
plotRGB(typhoon, r=3, g=2, b=1)

# The Mato Grosso image can be downloaded directly from EO-NASA:

mato <- rast("matogrosso_l5_1992219_lrg.jpg")
plotRGB(mato, r=1, g=2, b=3) 
plotRGB(mato, r=2, g=1, b=3) 

#--------------------

# 08 Copernicus data

# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html

library(ncdf4)
library(terra)

# install.packages("name_of_the_package_here")

setwd("~/Downloads") # in W*****s \ means /

soilm2023 <- rast("c_gls_SSM1km_202311250000_CEURO_S1CSAR_V1.2.1.nc")
plot(soilm2023)

# there are two elements, let's use the first one!
plot(soilm2023[[1]])

cl <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(soilm2023[[1]], col=cl)

ext <- c(22, 26, 55, 57) # minlong, maxlong, minlat, maxlat
soilm2023c <- crop(soilm2023, ext)

plot(soilm2023c[[1]], col=cl)

# new image
soilm2023_24 <- rast("c_gls_SSM1km_202311240000_CEURO_S1CSAR_V1.2.1.nc")
plot(soilm2023_24)
soilm2023_24c <- crop(soilm2023_24, ext)
plot(soilm2023_24c[[1]], col=cl)

#--------------------

# 09 Classification

# Classifying satellite images and estimate the amount of change

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

im.list()

# https://www.esa.int/ESA_Multimedia/Images/2020/07/Solar_Orbiter_s_first_views_of_the_Sun6
# additional images: https://webbtelescope.org/contents/media/videos/1102-Video?Tag=Nebulas&page=1

sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

sunc <- im.classify(sun, num_clusters=3)

# classify satellite data

im.list()

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
  
m1992c <- im.classify(m1992, num_clusters=2)                    
plot(m1992c)
# classes: forest=1; human=2

m2006c <- im.classify(m2006, num_clusters=2)
plot(m2006c)
# classes: forest=1; human=2

par(mfrow=c(1,2))
plot(m1992c[[1]])
plot(m2006c[[1]])

f1992 <- freq(m1992c)
f1992
tot1992 <- ncell(m1992c)
# percentage
p1992 <- f1992 * 100 / tot1992 
p1992
# forest: 83%; human: 17%

# percentage of 2006
f2006 <- freq(m2006c)
f2006
tot2006 <- ncell(m2006c)
# percentage
p2006 <- f2006 * 100 / tot2006 
p2006
# forest: 45%; human: 55%

# building the final table
class <- c("forest", "human")
y1992 <- c(83, 17)
y2006 <- c(45, 55) 

tabout <- data.frame(class, y1992, y2006)
tabout

# final output
p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")
p1 + p2

# final output, rescaled
p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p2 <- ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p1 + p2

#--------------------

# 10 Variability

# measurement of RS based variability

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

# band 1 = NIR
# band 2 = red
# band 3 = green

im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)

nir <- sent[[1]]
plot(nir)

# moving window
# focal
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)
plot(sd3)

viridisc <- colorRampPalette(viridis(7))(255)
plot(sd3, col=viridisc)

# Exercise: calculate variability in a 7x7 pixels moving window
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)
plot(sd7, col=viridisc)

# Exercise 2: plot via par(mfrow()) the 3x3 and the 7x7 standard deviation
par(mfrow=c(1,2))
plot(sd3, col=viridisc)
plot(sd7, col=viridisc)

# original image plus the 7x7 sd
im.plotRGB(sent, r=2, g=1, b=3)
plot(sd7, col=viridisc)

#--------------------

# 11 Principal Component Abalysis

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent)

# perform PCA on sent
sentpc <- im.pca(sent)
pc1 <- sentpc$PC1

viridisc <- colorRampPalette(viridis(7))(255)
plot(pc1, col=viridisc)

# calculating standard deviation ontop of pc1
pc1sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
plot(pc1sd3, col=viridisc)

pc1sd7 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)
plot(pc1sd7, col=viridisc)

par(mfrow=c(2,3))
im.plotRGB(sent, 2, 1, 3)
# sd from the variability script:
plot(sd3, col=viridisc)
plot(sd7, col=viridisc)
plot(pc1, col=viridisc)
plot(pc1sd3, col=viridisc)
plot(pc1sd7, col=viridisc)

# stack all the standard deviation layers
sdstack <- c(sd3, sd7, pc1sd3, pc1sd7)
names(sdstack) <- c("sd3", "sd7", "pc1sd3", "pc1sd7")
plot(sdstack, col=viridisc)

#--------------------
