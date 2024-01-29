# We will learn how to measure RS-based variability

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

# band 1 = NIR
# band 2 = red
# band 3 = green

im.plotRGB(sent, r = 1, g = 2, b = 3)
im.plotRGB(sent, r = 2, g = 1, b = 3)

nir <- sent[[1]]
plot(nir)

### Using a moving window and the focal function ###

sd3 <- focal(nir, matrix(1/9, 3, 3), fun = sd) # the focal() function takes an image (a raster) as first argument, 
# a matrix of weights (the moving window) as second argument and a function as an optional third argument. 
# Here, the function calculates the standard deviation, which is what "sd" stands for.
# The first value in the matrix function's parameters is the weight of each point of the moving window.
# The next two are the number of columns and rows respectively.
# Description of the focal() function: 
# "calculate focal ("moving window") values for the neighborhood of focal cells using a matrix of weights, perhaps in combination with a function"
plot(sd3)

viridisc <- colorRampPalette(viridis(7))(255)
plot(sd3, col = viridisc)

### Exercise: calculate variability in a 7x7 pixels moving window ###

sd7 <- focal(nir, matrix(1/49, 7, 7), fun = sd)
plot(sd7, col = viridisc)

### Exercise : plot via par(mfrow = c()) the 3x3 and the 7x7 standard deviation ###

par(mfrow = c(1,2))
plot(sd3, col = viridisc)
plot(sd7, col = viridisc)

#### Plotting the original image plus the 7x7 sd ###

im.plotRGB(sent, r = 2, g = 1, b = 3)
plot(sd7, col = viridisc)
