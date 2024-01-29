# We will use a library for community ecology called vegan. Link to its documentation: https://cran.r-project.org/web/packages/vegan/

library(vegan)

data(dune) # loads the dune dataset. It concerns vegetation and environment in Dutch dune meadows (see documentation). The data() function is the standard way of loading data
head(dune) # returns the start of the dataset

ord <- decorana(dune) # description of the decorana() function: "Performs detrended correspondence analysis (DCA) and basic reciprocal averaging or orthogonal correspondence analysis." 
# DCA is a multivariate statistical method used in ecology to analyze and visualize species composition data

#### Storing the lengths of the first 4 axes of the DCA in 4 variables ###

ldc1 = 3.7004
ldc2 = 3.1166 
ldc3 = 1.30055
ldc4 = 1.47888

# We can use "=" instead of "<-" because we're manipulating numbers

### Calculating the contribution of each axis to the total axis length (as a percentage) ###

total = ldc1 + ldc2 + ldc3 + ldc4

pldc1 = ldc1 * 100 / total
pldc2 = ldc2 * 100 / total
pldc3 = ldc3 * 100 / total
pldc4 = ldc4 * 100 / total

### Displaying two of the contributions, their sum and the DCA of ord ###

pldc1
pldc2

pldc1 + pldc2

# Together, the first two axes contribute around 71.04% of the total variation in the data. The first axis contributes the most to it (38.56%)

plot(ord) 
