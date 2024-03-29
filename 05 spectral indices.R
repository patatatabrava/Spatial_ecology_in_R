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
