# A package is needed for point pattern analysis. Here is its description: https://cran.r-project.org/web/packages/spatstat/index.html
install.packages("spatstat") # this line is for installing the spatstat library into R
library(spatstat) # that one is for calling it for this paticular script

# We will use the bei dataset from the spatstat library.
bei

plot(bei, cex=.2, pch=19) # plots bei as a set of full points of size .2

############################################## Stopped working here!!!!!!!!!!!!!!!!!!!

# additional datasets
bei.extra
plot(bei.extra)

# let's use only part of the dataset: elev
plot(bei.extra$elev)
elevation <- bei.extra$elev
plot(elevation)

# second method to select elements
elevation2 <- bei.extra[[1]]
plot(elevation2)

# passing from points to a countinuous surface
densitymap <- density(bei)
plot(densitymap)
points(bei, cex=.2)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100)
plot(densitymap, col=cl)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(4)
plot(densitymap, col=cl)

clnew <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(densitymap, col=clnew)

plot(bei.extra)

elev <- bei.extra[[1]] # bei.extra$elev
plot(elev)

# multiframe
par(mfrow=c(1,2))
plot(densitymap)
plot(elev)

par(mfrow=c(2,1))
plot(densitymap)
plot(elev)

par(mfrow=c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
