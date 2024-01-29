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

### Generating a base map of the states in which the spotted owl lives ###

# Storing the data from maps into variables #

wash <- "washington"
ore <- "oregon"
cal <- "california"
nev <- "nevada"

# Getting the information on the borders of the counties of each state #

# Our aim is to make a precise map.
# Here is a description of the county_info data for any given state:
# "This data set describes the shape of each county in the state by specifying 
# the latitude and longitude of the corners of polygons that approximate the shapes. 
# The group column indicates the county to which the corresponding set of polygon corners belongs. 
# For example, for California, group 1 corresponds to Alameda county, group 2 is Alpine county, and so on. 
# The order column specifies the order in which the points should be connected to correctly draw each polygon. 
# Finally, the region identifies the state and the subregion identifies the county."

county_info_wash <- map_data("county", region = wash)
county_info_ore <- map_data("county", region = ore)
county_info_cal <- map_data("county", region = cal)
county_info_nev <- map_data("county", region = nev)

# Building the base map with the ggplot function #

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

# To have all states in one plot, we need to call the ggplot() function only once.
# With "data = county_info_wash", we feed it the data on the counties for one of the states: Washington.
# The statement "mapping = aes(x = long, y = lat, group = group)" specifies the aesthetics of the plot: 
# we want the longitude of the points on the x-axis, their latitude on the y-axis, and we want the points
# which share the same value for the group variable in the data frame to be part of a same group in the plot
# (in "group = group", the first "group" is a parameter of the ggplot() function, while the second one is 
# the name of a variable in the data frame).
# We end the line with a '+' to state that more layers will be added to the plot.
# The statement "geom_polygon(color = "black", fill = "white")" adds a layer of polygons with black edges and
# white fillings connecting points of a same group to the plot.
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

setwd("C://Users/acer/Desktop/Occurrences Northern Spotted Owl") # sets the working directory to the one containing the data
occ <- read_tsv("occurrences.csv", quote = "") # reads the file from the directory and stores it in a data frame called occ
occ # shows a table with the data
occ_nw <- occ[occ$stateProvince == "Washington" | occ$stateProvince == "Oregon" | occ$stateProvince == "California" | occ$stateProvince == "Nevada",] # selects the observations in the states we're studying; the "|" symbol is a logical "or"
occ_nw_notNA <- occ_nw[is.na(occ_nw$year) == FALSE,] # selects the data for which the year variable is not unknown; "na" stands for "not available"

### Adding the data to the base map ###

map_with_data <- base_map +  
  geom_point(data = occ_nw_notNA, aes(x = decimalLongitude, y = decimalLatitude, group = year), color = "orange")
map_with_data

### Animating the map ###

map_with_animation <- map_with_data +
  transition_time(year) +
  ggtitle('Year: {frame_time}', subtitle = 'Frame {frame} of {nframes}')
num_years <- max(occ_nw_notNA$year) - min(occ_nw_notNA$year) + 1
animate(map_with_animation, nframes = num_years, fps = 2)
anim_save("without shadow.gif") # saves the animation to a .gif file in the working directory

### Making an animation with shadow ###

map_with_shadow <- base_map +
  geom_point(data = occ_nw_notNA, aes(x = decimalLongitude, y = decimalLatitude, group = year, color = year)) +
  transition_time(year) +
  ggtitle('Newest year: {frame_time}', subtitle = 'Frame {frame} of {nframes}') +
  shadow_mark() +
  scale_color_gradient(low = "yellow", high = "red")
num_years <- max(occ_nw_notNA$year) - min(occ_nw_notNA$year) + 1
animate(map_with_shadow, nframes = num_years, fps = 2)
anim_save("with shadow.gif")
