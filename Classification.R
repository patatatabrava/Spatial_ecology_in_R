# Classifying satellite images and estimating the amount of change

library(imageRy)
library(terra)

im.list()
sun <- im.import("Solar_orbiter_s_first_viezs_of_the_Sun_pillars.jpg")
im.classify(sun, num_clusters = 3)
