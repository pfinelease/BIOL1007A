### Vectors, Matrices, Data Frames, and Lists
### January 17, 2023
### PFL

####Vectors Continued
###Properties

##Coercion
#All atomic vectors are of the same data type
# IF you use c() to assemble different types, R coerces them
#Logical -> integer -> double -> character 
# always goes down to the base type (towards character)

a<- c(2,2.2)
a
#notice that because there is one integer that is a double (has a tenths place), both values become doubles

b <- c("purple", "green")
typeof(b)

d <- c(a,b)
d

#### Comparison operators yeild a logical result

a <- runif(10)
print(a)
#runif is a package that simulates random, uniform numbers


a>0.5 #conditional statement

### how many elements in the vector are a>0.5
sum(a>0.5)
mean(a>0.5)


####Vectorization
###add a constant to a vector

z <- c(10,20,30)
z + 1
#1 is added to each element of the vector

## what happens when vectors are added together?
y <- c(1,2,3)
z+y
#results in an "element by element" operation on the vector

z^2


##Recycling
#what if vector lengths are not equal?

z
x<- c(1,2)
z + x 
#a warning is issued but the calculation is still made 
#the shorter vector is recycled: 1 was added to 10, 2 was added to 20, and then 1 was added again to 30


#######Simulating data: runif and rnorm()

runif(5)
#this gives us 5 random numbers
#we can change the min and max
runif(n=5, min=5, max=10)
#n= sample size
#min=minimum value
#max=maximimum value

set.seed(123) 
#this can be any number
#set.seed talks to the random number generator and tells it to reuse the same random numbers: get random numbers, run set.seed and run the random number generator again for them to reproduce


### rnorm  : random normal values within mean 0 and standard deviation (sd) of 1

randomNormalNumbers <- rnorm(100)
mean(randomNormalNumbers)

# hist function shows the distribution ex: hist(runif(n=100, min=5,max=10))

rnorm(n=100, mean=100, sd=30))
hist(rnorm(n=100, mean=100, sd=30))



####### Matrix data structures
#### 2 dimensional (rows and columns)
### homogenous data types (one type)

#matrix is an atomic vector organized into rows and columns

my_vec <- 1:12

m <- matrix(data=my_vec, nrow=4)
m

m <- matrix(data = my_vec, ncol=3)
m

m <- matrix(data = my_vec, ncol=3, byrow=T)
m



##### Lists
### are atomic vectors BUT each element can hold different data types (and different sizes)

mylist <- list(1:10, matrix(1:8, nrow=4, byrow=TRUE), letters[1:3], pi)
class(mylist)
#TELLS us that we have a list

str(mylist)
#gives us a preview of what is in our list



####subsetting lists
## using [] gives you a single item BUT not the elements
mylist[4]
mylist[4] -3 #this does not work: single brackets [] gives you only elements in solt which is always type list

# to grab object itself, use [[]]
mylist[[4]]
mylist[[4]] - 3 # now we access contents

mylist[[2]][4,1] #access the list using mylist then we want the 2 element so we do [[2]] and then we will look into the second element in the 4th row and first column so the value of 7
 mylist[c(1,2)] # to obtain multiple compartments of list
 
 c(mylist[[1]], mylist[[2]]) # to obtain multiple elements within list
 
 ### Name list items when they are created
 
 mylist2 <- list(Tester=FALSE, littleM = matrix(1:9, nrow=3))
mylist2

mylist2$Tester
#since we names the elements, we can use the $ to refer to the element

mylist2$littleM[2,3] #extracts 2nd row 3rd column of littleM

mylist2$littleM[2,] # we left the [2,] blank after the 2 to indicate that we wanted to look at the second row and all columns

mylist2$littleM[2] #gives second element (which happens to be the value 2)


###unlist to string everything back to vector
unrolled <- unlist(mylist2)
unrolled
#0=false and 1=true

data(iris) #iris is a data set that has to do with sepal and petal width
head(iris) #head lets us see the first 6 rows of data
plot(Sepal.Length ~ Petal.Length, data = iris) #always do y data ~ x data ; make sure capitalization is the same
model <- lm(Sepal.Length ~ Petal.Length, data = iris)
#lm = linear model
results <- summary(model) #under intercept, Petal.Length shows us that the P-value is very small so the relationship is significant; there is also a p-value in the little summary at the end

#Quick Assignment
str(results)
results$coefficients
results$coefficients[2,4]
results[[4]][2,4]

unlist(results)$coefficients8

### Data Frames
## equaul-lengthened vectors, each of which is a column

varA <- 1:12
varB <- rep(c("Con", "LowN", 'HighN'), each =4)
varC <- runif(12)

dFrame <- data.frame(varA, varB, varC, stringsAsFactors = FALSE)
print(dFrame)
str(dFrame)

#add another row
newData <- list(varA=13, varB="HighN", varC=0.668)


# use rbind() to add a row
dFrame <- rbind(dFrame, newData)
dFrame

##why cant we use c?
newData2 <- c(14, "HighN", 0.668)
#coerces to character
dFrame < rbind(dFrame, newData2) #all charcter data types now!


### Add a column
newVar <- runif(12) #the 12 has to be the correct number of rows

# use cbind() function to add column
dFrame <- cbind(dFrame,newVar)
head(dFrame)



### Data frames vs Matrices
zMat <- matrix(data=1:30, ncol=3, byrow=T)
zMat 
zDframe <- as.data.frame(zMat) #
zDframe 
#data frame made up header names because we did not provide them (V1,V2,V3)
str(zDframe)
str(zMat)

zMat[3,3]
zDframe[3,3]
#gives us the same value because we are referencing the same thing

zMat[,3]
zDframe[,3]
#same thing
zDframe$V3 #data frame gave a name to the column so we can reference it using the $ 


zMat[3,]
zDframe[3,]

zMat[3] #gives us the third element
zDframe[3] #the third element in the data frame is the whole third column


#### Eliminating NAs 
### complete.cases() function
zD <- c(NA, rnorm(10), NA, rnorm(3))
zD
complete.cases(zD) 

#clean out NAs
zD[complete.cases(zD)]
which(!complete.cases(zD)) #tells us where NAs are
which(is.na(zD)) #same as ^



### use with matric
m <- matrix(1:20, nrow=5)
m
m[1,1] <- NA
m[5,4] <- NA
m
complete.cases(m) #gives T/F as to whether whole row is 'complete' (no NAs)
m[complete.cases(m),]

##get complete cases for only certain rows
m[complete.cases(m[,c(1:2)]),] #we are only looking at the first two columns, not the entire mattrix and end with a , so that we get all that meet the condition
