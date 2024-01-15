# We will work with vegetation indices

library(imageRy)
library(terra)

im.list() # we want to know the name of the image we need to import, so we have a look at the list of all the data in imageRy

### Importing and plotting the old image of the Mato grosso ###

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")   
# The bands are in the following order: 1 = NIR, 2 = red, 3 = green
im.plotRGB(m1992, r = 1, g = 2, b = 3)
im.plotRGB(m1992, 1, 2, 3) # different syntax for doing the same thing as in the previous line
im.plotRGB(m1992, r = 2, g = 1, b = 3) 
im.plotRGB(m1992, r = 2, g = 3, b = 1) # in this plot, the red is on the red, the green is on the green, and the NIR is on the blue. There is no blue in our file, so we can't make a normal RGB plot

### Importing and plotting the recent image of the Mato grosso ###

m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r = 2, g = 3, b = 1)

### Building a multiframe with the 1992 and 2006 images ###

par(mfrow = c(1,2))
im.plotRGB(m1992, r = 2, g = 3, b = 1)
im.plotRGB(m2006, r = 2, g = 3, b = 1)

### Taking the difference between the NIR and red bands in the old image and plotting it ###

# Recall that the bands are in the following order: 1 = NIR, 2 = red, 3 = green

dvi1992 = m1992[[1]] - m1992[[2]] # here, we (can) use "=" and not "<-" because we are making an operation
plot(dvi1992)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col = cl)

### Exercise: calculate the dvi (ie the difference between the NIR and red bands) of 2006 ###

dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006, col = cl)

### Calculating and plotting ndvi, the quotient between dvi and the sum of the NIR and red bands, for the old image ###

# I don't understand what ndvi represents
ndvi1992 = dvi1992 / (m1992[[1]] + m1992[[2]])
plot(ndvi1992, col = cl)

### Calculating and plotting ndvi for the new image ###

ndvi2006 = dvi2006 / (m2006[[1]] + m2006[[2]])
plot(ndvi2006, col = cl)

### Making a multiframe with both plots ###

par(mfrow = c(1,2))
plot(ndvi1992, col = cl)
plot(ndvi2006, col = cl)

### Making another multiframe with a different color scheme and the same data ###

clvir <- colorRampPalette(c("violet", "dark blue", "blue", "green", "yellow"))(100)
par(mfrow = c(1,2))
plot(ndvi1992, col = clvir)
plot(ndvi2006, col = clvir)

### Using a function from imageRy to speed up the calculation ###

ndvi2006a <- im.ndvi(m2006, 1, 2)
plot(ndvi2006a, col = cl)
