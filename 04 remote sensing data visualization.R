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
