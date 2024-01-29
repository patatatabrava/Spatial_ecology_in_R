# We will learn how to analyse time series

library(imageRy)
library(terra)

im.list()

### Importing the data ###

EN01 <- im.import("EN_01.png")
EN13 <- im.import("EN_13.png")

# These images represent the NO_2 levels in Europe, in January and March respectively. Cities with higer NO_2 levels appear in red.
# Interpretation: in March, the levels of NO_2 were lower

par(mfrow = c(2,1))
im.plotRGB.auto(EN01) # plots the January image in RGB. I'm not sure why this "auto" is here, though
im.plotRGB.auto(EN13)

### Using the first element (band) of images ###

dif = EN01[[1]] - EN13[[1]]

# Visualizing the difference between the two images helps grasp the difference in NO_2 levels between the two months

### Building the palette ###

cldif <- colorRampPalette(c("blue", "white", "red")) (100) # this is a very commonly used palette for representing differences
plot(dif, col = cldif)

# Interpretation: red points are places where the NO_2 levels were higher in January, blue points are places where the NO_2 levels were higher in March.
# Big cities being red can be explained by the lockdown

### New example: temperature in Greenland ###

# These images come from the Copernicus program. They represent temperatures in Greenland in different years

g2000 <- im.import("greenland.2000.tif")
clg <- colorRampPalette(c("black", "blue", "white", "red")) (100)
plot(g2000, col = clg)

g2005 <- im.import("greenland.2005.tif")
g2010 <- im.import("greenland.2010.tif")
g2015 <- im.import("greenland.2015.tif")

plot(g2015, col = clg)

par(mfrow = c(1,2))
plot(g2000, col = clg)
plot(g2015, col = clg)

# The multiframe helps compare the two years. 
# Interpretation: in 2015, the central part of Greenland, which is a perennial ice cap, was hotter than in 2005. The ice melted between the two years

### Stacking the data ###

stackg <- c(g2000, g2005, g2010, g2015)
plot(stackg, col = clg) # plots the stack like in a multiframe

# Interpretation: 2005 was the worst year, temperatures increased sharpely between 2000 and 2005

### Exercise: make the difference between the first and the final elements of the stack ###

difg <- stackg[[1]] - stackg[[4]]
plot(difg, col = cldif)

# Interpretation: in the central part of Greenland, the temperature was lowest in 2005; in the East coast of Canada, the situation is reversed

### Exercise: make a RGB plot using different years ###

im.plotRGB(stackg, r = 1, g = 2, b = 3)
