# Ressource: https://conservancy.umn.edu/bitstream/handle/11299/220339/time-maps-tutorial-v2.html?sequence=3&isAllowed=y

### Installing the packages to make and use animated maps ###

install.packages("gganimate")
install.packages("gifski")
install.packages("maps")
install.packages("readr")

### Loading the packages ###

library(ggplot2) # serves for making plots, is used as a base for gganimate
library(gganimate) # serves for making animations
library(gifski) # turns animations into gifs
library(maps) # contains info on the boundaries of many geographical regions
library(readr) # serves for reading rectangular data, here .csv files
library(terra) # contains methods for spatial data analysis with vector and raster data

### Generating a base map of the states in which the spotted owl lives ###

# Storing the data from maps into variables #

wash <- "washington"
ore <- "oregon"
cal <- "california"
nev <- "nevada"

# Getting the information on the borders of the counties of each state #

# Our aim is to make a precise map.
# Here is a description of the county dataset:
# "This data set describes the shape of the counties of each state by specifying 
# the latitude and longitude of the corners of polygons that approximate the shapes. 
# The group column indicates the county to which the corresponding set of polygon corners belongs. 
# For example, for California, group 1 corresponds to Alameda county, group 2 is Alpine county, and so on. 
# The order column specifies the order in which the points should be connected to correctly draw each polygon. 
# Finally, the region identifies the state and the subregion identifies the county."

county_info_wash <- map_data("county", region = wash)
county_info_ore <- map_data("county", region = ore)
county_info_cal <- map_data("county", region = cal)
county_info_nev <- map_data("county", region = nev)
# The map_data() function, from the maps package, is used to access the data and to turn it into a data frame 
# which can be plotted with ggplot().

# Building the base map with the ggplot() function #

base_map <- 
  # Washington
  ggplot(data = county_info_wash, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill = "white") +
  # Oregon
  geom_polygon(data = county_info_ore, mapping = aes(x = long, y = lat, group = group), color = "black", fill = "white") +
  # California
  geom_polygon(data = county_info_cal, mapping = aes(x = long, y = lat, group = group), color = "black", fill = "white") +
  # Nevada
  geom_polygon(data = county_info_nev, mapping = aes(x = long, y = lat, group = group), color = "black", fill = "white") +

  coord_quickmap() +
  theme_void()

# To have all states in one plot, we must make only one call to the ggplot() function.
# With "data = county_info_wash", we feed it the data on the counties for one of the states: Washington.
# The statement "mapping = aes(x = long, y = lat, group = group)" specifies the aesthetics of the plot: 
# we want the longitude of the points on the x-axis, their latitude on the y-axis, and we want the points
# that have the same value in the group column in the data frame to be part of a same group in the plot
# (in "group = group", the first "group" is a parameter of the ggplot() function, while the second one is 
# the name of a column in the data frame).
# We end the line with a '+' to state that more layers will be added to the plot.
# The statement "geom_polygon(color = "black", fill = "white")" adds a layer of polygons with black edges and
# white fillings connecting points of a same group in the plot.
# For the next states, we specify the datasets and the aesthetics directly in the geom_polygon() function to 
# avoid making another call to the ggplot() function.
# The function coord_quickmap() scales the axes in a way that looks natural for a map.
# The function theme_void() gives an empty background to the map.

base_map # shows the map

# Method 2: making a data frame with the county info of all the states together and plotting it #

# We want to keep the groups of counties separate between each state, otherwise, we will
# get lines connecting points from two different states to one another in our map.
# To do so, we add the sum of the maximal group numbers from each previous state to the
# group numbers of the next state.
# 
# a <- max(county_info_wash$group) # will be added to the Oregon group numbers
# b <- a + max(county_info_ore$group) # will be added to the California group numbers
# c <- b + max(county_info_cal$group) # will be added to the Nevada group numbers
# 
# county_info <- data.frame('lat' = c(county_info_wash$lat, county_info_ore$lat, county_info_cal$lat, county_info_nev$lat),
#                         'long' = c(county_info_wash$long, county_info_ore$long, county_info_cal$long, county_info_nev$long),
#                         'group' = c(county_info_wash$group, county_info_ore$group + a, county_info_cal$group + b, county_info_nev$group + c),
#                         'order' = c(county_info_wash$order, county_info_ore$order, county_info_cal$order, county_info_nev$order),
#                         'region' = c(county_info_wash$region, county_info_ore$region, county_info_cal$region, county_info_nev$region),
#                         'subregion' = c(county_info_wash$subregion, county_info_ore$subregion, county_info_cal$subregion, county_info_nev$subregion))
# 
# base_map <- ggplot(data = county_info, mapping = aes(x = long, y = lat, group = group)) +
#   geom_polygon(color = "black", fill = "white") +
#   coord_quickmap() +
#   theme_void() 
# 
# base_map

### Getting the occurrences of northern spotted owls and cleaning up the data ###

# The data was downloaded from this page (I chose the simple version): https://www.gbif.org/occurrence/download/0077685-231120084113126.
# DOI: 10.15468/dl.rx8u8v

setwd("C://Users/acer/Desktop/Project Spatial Ecology in R") # sets the working directory to the one containing the data
occ <- read_tsv("occurrences.csv", quote = "") # reads the file from the directory and stores it in a data frame called occ

head(occ) # shows a table with the start of the data
occ_notNA <- occ[is.na(occ$year) == FALSE & is.na(occ$decimalLatitude) == FALSE & is.na(occ$decimalLongitude) == FALSE,] 
# The last line selects the data for which a value is available in the year, decimalLatitude and decimalLongitude columns
# of the occ data frame and stores it in a new data frame; "na" stands for "not available".

### Adding the data to the base map ###

# Observations from all the years will be featured in a single image.

map_with_data <- base_map +  
  geom_point(data = occ_notNA, aes(x = decimalLongitude, y = decimalLatitude, group = year), color = "orange")
# This line adds a layer to the previous plot, which is why the right-hand side starts with "base_map".
# The added layer shows as points thanks to the geom_point() function. Its arguments play the same role
# those of the geom_polygon() did when it was called to draw Oregon, California and Nevada for the base map.

map_with_data # shows the map with the data

### Animating the map ###

map_with_animation <- map_with_data +
  transition_time(year) +
  ggtitle('Year: {frame_time}', subtitle = 'Frame {frame} of {nframes}')
# We are adding more layers to the map_with_data object.The function transition_time() takes as an argument
# the column of the data frame that we want to use to transition from one image in the animation to the next.
# Here, we've selected "year".
# The ggtitle() function gives a title to each of the frames. The first argument contains the title,
# while the second contains a subtitle. The frame_time parameter is the time index of the frame currently 
# being displayed, so, here, it corresponds to the year of the observations. 
# The frame parameter refers to the index in the sequence of frames of the current frame, and nframe is 
# the total number of frames.

num_years <- max(occ_notNA$year) - min(occ_notNA$year) + 1 # calculates the total number of years in the dataset and stores it in a variable
animate(map_with_animation, nframes = num_years, fps = 2) # animates the map_with_animation object, specifying that the total number of
# frames should be num_years and that we want to display two frames per second (fps)

anim_save("without shadow.gif") # saves the animation to a .gif file in the working directory

### Making an animation with the shadow of previous points ###

map_with_shadow <- base_map +
  geom_point(data = occ_notNA, aes(x = decimalLongitude, y = decimalLatitude, group = year, color = year)) +
  transition_time(year) +
  ggtitle('Newest year: {frame_time}', subtitle = 'Frame {frame} of {nframes}') +
  shadow_mark() +
  scale_color_gradient(low = "orange", high = "darkblue") # this color gradient was chosen to resemble the inferno palette from the viridis package
# This is very similar to the code used to create the map without shadow. However, we cannot simply add layers 
# to the map_with_data object because we have to specify that a different color should be attributed to each year value 
# in the data frame, which is the purpose of the "color = year" statement.
# We also add a layer with the shadow_mark() function to keep the points of the previous frames on the current one,
# and, with the last line, we specify that the color gradient should go from orange to blue.

num_years <- max(occ_notNA$year) - min(occ_notNA$year) + 1
animate(map_with_shadow, nframes = num_years, fps = 2)

anim_save("with shadow.gif")
# These three last lines are identical to the ones used in the previous chunk of code.

### Making rasters with the Landsat 8 images ###

# NIR is band 5, red is band 4
# The images are of a patch of forest at the border between Oregon and California

band4_2022 <- rast("Landsat8_2022_B4.tif")
band4_2021 <- rast("Landsat8_2021_B4.tif")
band4_2019 <- rast("Landsat8_2019_B4.tif")
band4_2018 <- rast("Landsat8_2018_B4.tif")
band5_2022 <- rast("Landsat8_2022_B5.tif")
band5_2021 <- rast("Landsat8_2021_B5.tif")
band5_2019 <- rast("Landsat8_2019_B5.tif")
band5_2018 <- rast("Landsat8_2018_B5.tif")
# The rast() function creates a raster from the image which is fed to it.

### Calculating the DVI for each year ###

dvi_2022 <- band5_2022 - band4_2022
dvi_2021 <- band5_2021 - band4_2021
dvi_2019 <- band5_2019 - band4_2019
dvi_2018 <- band5_2018 - band4_2018

### Calculating the NDVI for each year ###

# The NDVI is better suited for comparing different images than the DVI because it is normalized.
# Thus, the interpretation doesn't get biased by the potential differences in total reflectance.

ndvi_2022 <- dvi_2022/(band5_2022 + band4_2022)
ndvi_2021 <- dvi_2021/(band5_2021 + band4_2021)
ndvi_2019 <- dvi_2019/(band5_2019 + band4_2019)
ndvi_2018 <- dvi_2018/(band5_2018 + band4_2018)

# A low NDVI can indicate that the trees are conifers, while a high NDVI suggests hardwood trees.

### Plotting the NDVI for each year in a multiframe ###

cl <- colorRampPalette(c("black","darkgreen","grey","white"))(100)
# The colorRampPalette() funtion creates a color palette from the array which is fed to it.
# The number in parentheses sets the number of intermediate colors between each of the colors in the array. 

par(mfrow = c(2,2)) # creates a 2x2 multiframe 
plot(ndvi_2022, main = "NDVI in 2022", col = cl) # the "main" parameter contains the title of the plot
plot(ndvi_2021, main = "NDVI in 2021", col = cl)
plot(ndvi_2019, main = "NDVI in 2019", col = cl)
plot(ndvi_2018, main = "NDVI in 2018", col = cl)
