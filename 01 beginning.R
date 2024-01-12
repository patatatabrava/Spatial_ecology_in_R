# R can be used to make calculations. You don't have to use "print" to visualize the output of a function, it automatically appears in the console, after a quotation of that line of code (at least in R studio)
2 + 3

# This is the way you assign a value to an object:
zima <- 2 + 3
zima # shows the value contained in zima

duccio <- 5 + 3
duccio

final <- zima * duccio # this is the syntax for multiplying 2 numbers together
final

final^2 # this is the syntax for taking exponents

# The c() function is used to make arrays. It forces all its arguments into a common type and its output is of the same type. "c" stands for "concatenate":
microplastics <- c(10, 20, 30, 50, 70) 
people <- c(100, 500, 600, 1000, 2000)

plot(people, microplastics) # shows the number of microplastics as a function of the number of people, without labelling the axes. Notice you don't need to import a library to make plots, unlike in Python

plot(people, microplastics, xlab = "number of people", ylab = "microplastics") # puts labels on the axes

plot(people, microplastics, pch = 19) # "pch = 19" selects point shape 19 (see tables on the interwebz)
# Link to such tables: https://www.google.com/search?client=ubuntu-sn&hs=yV6&sca_esv=570352775&channel=fs&sxsrf=AM9HkKknoSOcu32qjoErsqX4O1ILBOJX4w:1696347741672&q=point+symbols+in+R&tbm=isch&source=lnms&sa=X&ved=2ahUKEwia9brkm9qBAxVrQvEDHbEYDuMQ0pQJegQIChAB&biw=1760&bih=887&dpr=1.09#imgrc=lUw3nrgRKV8ynM

plot(people, microplastics, pch = 19, cex = 2) # "cex" stands for "character exageration", it chooses the size of the points
plot(people, microplastics, pch = 19, cex = 2, col = "blue") # "col = "blue"" is pretty self-explanatory
