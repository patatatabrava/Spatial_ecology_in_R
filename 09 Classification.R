# We will classify satellite images and estimate the amount of change

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

im.list()

# https://www.esa.int/ESA_Multimedia/Images/2020/07/Solar_Orbiter_s_first_views_of_the_Sun6
# additional images: https://webbtelescope.org/contents/media/videos/1102-Video?Tag=Nebulas&page=1

sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
sunc <- im.classify(sun, num_clusters = 3) # sorts the pixels in the image into 3 categories which are automatically determined
plot(sunc)

# If I get 3 images, it just means that I have an old version of imageRy

### Classifying satellite data ###

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
plotRGB(m1992)
plotRGB(m2006)

m1992c <- im.classify(m1992, num_clusters = 2)                    
plot(m1992c)

# Classes: forest = 1; humans = 2. At least, that's what the prof had, but mine might be different

m2006c <- im.classify(m2006, num_clusters = 2)
plot(m2006c)

# Same classes

par(mfrow = c(1,2))
plot(m1992c[[1]])
plot(m2006c[[1]])

# Now, we want to understand which proportions each class has in the image

f1992 <- freq(m1992c)
f1992

# The value in the column "layer" is 1 because we have only one layer in the image. 
# Apparently, this function can also be used with images with more than one layer

tot1992 <- ncell(m1992c) # ncell() gives the total number of pixels

### Calculating the percentage of forest in 1992 ###

p1992 <- f1992 * 100 / tot1992 
p1992

# forest: 83%; humans: 17%


### Calculating the percentage of forest in 2006 ###

f2006 <- freq(m2006c)
f2006

tot2006 <- ncell(m2006c)
p2006 <- f2006 * 100 / tot2006 
p2006

# forest: 45%; humans: 55%

### Building the final table ###

class <- c("forest", "human")
y1992 <- c(83, 17)
y2006 <- c(45, 55) 

tabout <- data.frame(class, y1992, y2006) # "tabout" as in "tab out"
tabout

### Final output ###

p1 <- ggplot(tabout, aes(x = class, y = y1992, color = class)) + geom_bar(stat = "identity", fill = "white")
# "aes" stands for "aesthetics", "bar" means we're using a histogram, the ylim-term is for using the same scale in both graphs
p2 <- ggplot(tabout, aes(x = class, y = y2006, color = class)) + geom_bar(stat = "identity", fill = "white")
p1 + p2 # gives the 2 plots together side-by-side thanks to the patchwork library

### Final output, rescaled ###

p1 <- ggplot(tabout, aes(x = class, y = y1992, color = class)) + geom_bar(stat = "identity", fill = "white") + ylim(c(0,100))
p2 <- ggplot(tabout, aes(x = class, y = y2006, color = class)) + geom_bar(stat = "identity", fill = "white") + ylim(c(0,100))
p1 + p2
