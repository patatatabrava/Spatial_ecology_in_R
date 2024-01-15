# We will study the relation among species in time. For this, we will use the overlap library. 
# This library contains functions to estimate the degree of overlap between the activity patterns of two species, tigers and macaques, based on camera trap data
# /!\ It is not on CRAN

library(overlap)

data(kerinci)
summary(kerinci) # summary() gives a summary of the object it takes as first argument, here the dataset kerinci

kerinci$timeRad <- kerinci$Time*2*pi # selects the time variable, puts it in radians and stores it in a new variable added to the data frame kerinci, called timeRad
# But why would you express a time in radians?

tiger <- kerinci[kerinci$Sps == "tiger",] # selects the elements in kerinci for which the Sps (species) variable is tiger

timetig <- tiger$timeRad # selects the time variable in the tiger data and stores it in a variable called timetig
densityPlot(timetig, rug = TRUE) # what does "rug = TRUE" mean?

### Exercise: select only the data on macaque individuals and plot it ###

macaque <- kerinci[kerinci$Sps == "macaque",]
head(macaque)
timemac <- macaque$timeRad
densityPlot(timemac, rug = TRUE)

overlapPlot(timetig, timemac) # shows the overlap between the tiger and macaque activity
