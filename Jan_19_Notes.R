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



#Functions in R
##everything in R is a function

sum(3,2) #sum function
3 + 2 # + sign is a function
sd

# User-defined functions

# functionName <- function(argX= defaultX, argY = defaultY){}
 
 ##{ } starts the body of the function so that you can put lines of R code, notes, local variables (only "visible" to R within the function)
# argX <- c("IDK")
 ## return(z) used within a variable/function
  # print() shows us what is in the variable; cant use within a function

myFunc <- function(a=3, b=4){
  z<- a+b
  return(z)
}
myFunc() #with open (), we are running the default: 3 +4
myFunc(a=3.4, b=100)

myFuncBad <- function(a=3){
  z <- a+b
  return(z)
}
myFuncBad() # wont work because we didnt specify b

myFuncBad <- function(a=NULL, b=NULL){
  z <- a+b
  return(z)
}
myFuncBad()
#dont name variables the same thing, 


###Multiple return statements
##########################
#FUNCTION: HardyWeingberg
# input: all allele rewuency p (0,1)
#output: p and the frequencies of the 3 genotypes AA AB BB
#___________________________________________________________


HardyWeinberg <- function(p=runif(1)){
if(p>1.0 | p<0.0){
  return("function failure: p must be between ) and 1")
}
  q <- 1-p
  fAA <- p^2
  fAB <- 2*p*q
  fBB <- q^2
  vecOut <- signif(c(p=p, AA=fAA, AB=fAB, BB=fBB), digits = 3)
  return(vecOut)
} 
#trouble shooting: copy and paste your code outside of the function and see if it works: 
# q <- 1-p
#fAA <- p^2
#fAB <- 2*p*q
#fBB <- q^2
#vecOut <- signif(c(p=p, AA=fAA, AB=fAB, BB=fBB), digits = 3)
#return(vecOut) 

####################################################
HardyWeinberg()
freqs <- HardyWeinberg()
freqs
HardyWeinberg(p=3)


### Create a complex default value
##################################################
#FUNCTION: fitlinear2
#fits simple regression line
#input: numeric list (p) of predictor (x) and response (y)
#outputs: slope and p-value

fitlinear2 <- function(p=NULL){
  if(is.null(p)){
    p <- list(x= runif(20), y = runif(20))
  }
  mymod <- lm(p$x~p$y)
  myout <- c(slope = summary(mymod)$coefficients[2,1],
             pValue=summary(mymod)$coefficients[2,4])
  plot(x=p$x, y=p$y) #quick plot to check output
  return(myout)
}
fitlinear2()
myPars <- list(x=1:10, y=runif(10))
fitlinear2(p=myPars)
