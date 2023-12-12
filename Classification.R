# Classifying satellite images and estimating the amount of change

library(imageRy)
library(terra)
library(ggplot2)
library(patchwork)

im.list()
sun <- im.import("Solar_orbiter_s_first_viezs_of_the_Sun_pillars.jpg")
sunc <- im.classify(sun, num_clusters = 3)
plot(sunc)

# If I get 3 images, it just means that I have an old version of imageRy

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
plotRGB(m1992)
plotRGB(m2006)

m1992c <- im.classify(m1992, num_clusters = 2)
plot(m1992c)

# classes: forest = 1; humans = 2. At least, that's what the prof had, but mine might be different.

par(mfrow = c(1,2))
plot(m1992c)
plot(m2006c)

# Now, we want to understand which proportions each classes have in the image.

f1992 <- freq(m1992c)

# The value in the column "layer" is 1 because we have only one layer in the image. Apparently, this function can also be used with images with more than one layer.

# Calculating the percentage of forest in 1992

tot1992 <- ncell(m1992c) # This function gives the total number of pixels
p1992 <- f1992 * 100 / tot1992
print(p1992)

# forest: 83%; humans: 17%

# Calculating the percentage of forest in 2006

tot2006 <- ncell(m2006c) # This function gives the total number of pixels.
p2006 <- f2006 * 100 / tot2006
print(p2006)

# forest: 45%; humans: 55%

# Building the final table

class <- c("forest","human")
y1992 <- c(83,17)
y2006 <- c(45,55)

tabout <- data.frame(class, y1992, y2006) # "tabout" as in "tab out" 
print(tabout)

# Final output

p1 <- ggplot(tabout, aes(x = class, y = y1992, color = class)) + geom_bar(stat = "identity", fill = "white") + ylim(c(0,100))
# "aes" stands for "aesthetics", "bar" means we're using a histogram, the ylim-term is for using the same scale in both graphs. 
p2 <- ggplot(tabout, aes(x = class, y = y2006, color = class)) + geom_bar(stat = "identity", fill = "white") + ylim(c(0,100))
p1
p2
# I don't understand when I should use "print" and when I shouldn't.
p1 + p2 # This gives the 2 plots together side-by-side thanks to the patchwork library.

