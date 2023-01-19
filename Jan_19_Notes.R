# Finishing Up Matricies and Data Frames
## January 19, 2023
##PFL

m <- matrix(data = 1:12, nrow=3)
m

### subsetting based on elements
m[1:2, ]
# the colon is a sequence statement, leaving the column indec blank gives us every column but only row 1 and 2
m[ ,2:4]

### subset with logical (conditional) statements
## select all columns for which totals are >15

colSums(m)
#gives us column sums of all in m
colSums(m) > 15
#gives us a logical output; last two columns add up over 15
m[ , colSums(m)>15]


## row sums now
#select rows that sum up to 22
m[rowSums(m)==22,]
#Gives us the row that adds to 22

m[rowSums(m)!=22,]
#!= means does not equal

##logical operators: ==    !=    >   < 
## subsetting to a vector changes the data type
z <- m[1,]
print(z)
str(z)

z2 <- m[1, , drop=F]
##adding drop=F will keep this as a matrix
typeof(z2)
class(z2)
class(z)


#simulate new matrix 
m2 <- matrix(data= runif(9), nrow=3)
m2
m2[6]
m2[3,2] #use this notation instead of ^

#we can use assignment operaatior to substitute values
m2[m2>0.6]
m2[m2<0.6]

m2[m2>0.6] <- NA
m2
# this can be helpful to change values that you know are wrong to NAs


data <- iris
head(data)

data[3,2] # this is recalling a data point using numbered indices

dataSub <- data[,c("Species", "Petal.Length")]
str(dataSub)

# sort a data frame by values
order(iris$Petal.Length)
orderedIris <- iris[order(iris$Petal.Length),]
head(orderedIris)
