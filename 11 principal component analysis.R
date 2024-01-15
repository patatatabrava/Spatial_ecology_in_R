# We will learn how to perform principal component analysis (PCA)

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent) # shows the correlations between each of the datasets

### Performing PCA on sent ###

sentpc <- im.pca2(sent) # the 2 is because they made an update to the package, and it might not work without it
pc1 <- sentpc$PC1

viridisc <- colorRampPalette(viridis(7))(255)
plot(pc1, col = viridisc)

### Calculating standard deviation on top of pc1 ###

pc1sd3 <- focal(pc1, matrix(1/9, 3, 3), fun = sd) # "sd" stands for "standard deviation"
plot(pc1sd3, col = viridisc)

pc1sd7 <- focal(pc1, matrix(1/49, 7, 7), fun = sd)
plot(pc1sd7, col = viridisc)

### Plotting everything together, just to get a view of everything we've done ###

par(mfrow = c(2,3))
im.plotRGB(sent, 2, 1, 3)
# sd from the variability script:
plot(sd3, col = viridisc)
plot(sd7, col = viridisc)
plot(pc1, col = viridisc)
plot(pc1sd3, col = viridisc)
plot(pc1sd7, col = viridisc)

### Stacking all the standard deviation layers (ie plotting with a different method) ###

sdstack <- c(sd3, sd7, pc1sd3, pc1sd7)
names(sdstack) <- c("sd3", "sd7", "pc1sd3", "pc1sd7")
plot(sdstack, col = viridisc)
