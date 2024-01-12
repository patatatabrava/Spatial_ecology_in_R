library(devtools)
devtools::install_github("clauswilke/colorblindr")
library(colorblindr)
library(ggplot2)

iris
head(iris) # shows the iris dataset

# Comparing the plot of the sepal length repartion of the flowers seen by a person with standard vision with the same plot seen by a colorblind person

fig <- ggplot(iris, aes(Sepal.Length, fill = Species)) + geom_density(alpha = 0.7)
fig # shows the figure

cvd_grid(fig) # "cvd" means "color vision deficiency". This function shows the way a colorblind person sees the figure it takes as an argument

names(iris) # gives all the variables in the dataset iris

# Comparing the plot of the sepal width repartion of the flowers seen by a person with standard vision with the same plot seen by a colorblind person

fig <- ggplot(iris, aes(Sepal.Width, fill = Species)) + geom_density(alpha = 0.7)
fig
  
cvd_grid(fig)
  
