library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent) # This shows the correlations between each of the datasets

# Perform PCA on sent

sentpc <- im.pca2(sent) # The 2 is because they made an update to the package, and it might not work without it.

