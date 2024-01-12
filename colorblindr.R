library(devtools)
devtools::install_github("clauswilke/colorblindr")
library(colorblindr)
library(ggplot2)

iris
head(iris) # shows the iris dataset

fig <- ggplot(iris, aes(Sepal.Length, fill = Species)) + geom_density(alpha = 0.7)
fig

cvd_grid(fig) # "cvd" means "color vision deficiency"

names(iris) # gives all the variables in the dataset iris
