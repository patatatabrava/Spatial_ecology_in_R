library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent) # This shows the correlations between each of the datasets

# Perform PCA on sent
sentpc <- im.pca2(sent) # The 2 is because they made an update to the package, and it might not work without it.
pc1 <- sentpc$PC1

viridisc <- colorRampPalette(viridis(7))(255)
plot(pc1, col = viridisc)

# Calculating standard deviation on top of pc1
pc1sd3 <- focal(pc1, matrix(1/9, 3, 3), fun = sd) # "sd" stands for "standard deviation"
plot(pc1sd3, col = viridisc)

pc1sd7 <- focal(pc1, matrix(1/9, 7, 7), fun = sd)
plot(pc1sd7, col = viridisc)
