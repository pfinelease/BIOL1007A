##### Simple Data Analysis and More Complex Control Structures 
### January 30, 2021
### PFL


dryadData <- read.table(file = "Data/veysey:babbit_data_amphibians.csv", header=T, sep=",")

#set up libraries
library(tidyverse)
library(ggthemes)
 ### Analyses
### Experimental designs
## independent/explanatory variable (x-axis) vs dependent/response variable (y axis)
## continuous (range of numbers: height, weight, temperature) vs discrete/categorical (categories: species, treatments, site)

glimpse(dryadData)
### Basic lenear regression analysis (2 continuous variable)
## is there a relationship between the mean pool hydroperiod and the number of breeding frogs caught?
# y ~ x variable 
regModel <- lm(count.total.adults ~ mean.hydro, data = dryadData)
summary(regModel) #p-value shows that they are strongly correlated 
hist(regModel$residuals)
summary(regModel)$"r.squared"
summary(regModel)[["r.squared"]] #same thing
View(summary(regModel))

regPlot <- ggplot(data=dryadData, aes(x=mean.hydro, y=count.total.adults+1)) + geom_point() + stat_smooth(method = lm, se=0.99)
 regPlot + theme_few()

 #### Basic ANOVA
 ### Was there a statistically significant difference in the number of adults among wetlands?
 # y variable ~ x variable
 
ANOmodel <- aov(count.total.adults ~ factor(wetland), data=dryadData)
summary(ANOmodel)

dryadData %>% 
  group_by(wetland) %>%
  summarise(avgHydro = mean(count.total.adults, na.rm=T), N=n()) 

## Boxplot 
dryadData$wetland <- factor(dryadData$wetland)
class(dryadData$wetland)

ANOplot2<- ggplot(data=dryadData, mapping = aes(x=wetland, y= count.total.adults, fill=species)) + geom_boxplot() + scale_fill_grey()
ANOplot2
#ggsave(file="SpeciesBoxplots.pdf", plot=ANOplot2, device = "pdf")


### Logisitic Regresson
## Data frame
#gamma probabilities - best for continuous variable that are always postive and have a skewed distribution
xVar <- sort(rgamma(n=200, shape=5, scale=5))
hist(xVar)
yVar <- sample(rep(c(1,0), each=100), prob=seq_len(200))
hist(yVar)
logRegData <- data.frame(xVar, yVar)

### Logistic regression analysis
logRegModel <- glm(yVar~xVar, 
                   data = logRegData,
                   family = binomial(link=logit))    #function to know for statistics!!!
summary(logRegData)

logRegPlot <- ggplot(data = logRegData,
                     aes(x=xVar, y=yVar)) +
  geom_point() + 
  stat_smooth(method = "glm", method.args=list(family=binomial))
logRegPlot  


### Contingency (both variables categorical) Table (Chi-squared) Analysis
## Are there differences in counts of males and females between species?

countData <- dryadData %>%
  group_by(species) %>% 
  summarise(Males= sum(No.males, na.rm=T), Females=sum(No.females, na.rm=T)) %>%
  select(-species) %>%
  as.matrix()
countData

row.names(countData) = c("SS", "WF")
countData

## Chi-squared
#get residuals
testResults <- chisq.test(countData)$residuals #the negative numbers means that there are less than expected, a 1 would mean as many as expected
testResults

testResults2 <- chisq.test(countData)
testResults2$residuals
testResults2$expected

#### mosaic plot (base R)
mosaicplot(x=countData,
           col=c("goldenrod","grey"),
           shade = F)
### Bar plot 
countDataLong <- countData %>%
  as.tibble() %>%
  mutate(Species = c(rownames(countData))) %>%
  pivot_longer(cols= Males:Females, 
               names_to = "Sex",
               values_to = "Count")
countDataLong

### Plot bar graph
plot3 <- ggplot(data= countDataLong,
                mapping=aes(x=Species, y=Count,, fill=Sex)) +
  geom_bar(stat = "identity", position="dodge") + #plots bars next to eachother
  scale_fill_manual(values=c("darkslategrey", "midnightblue"))
plot3


################################# Control Structure

## if and ifelse statements

##### if statements
### if(condition){expression 1}

### if(condition){expression 1} else {expression2}

### if(condition1){expression 1} else if(condition2){expression 2} else {expression3}
## if any final unspecified else, then captures the rest of (unspecified) conditions
##else must appear on the same line as the expression

# use it for single values
z <- signif(runif(1), digits=2)
z > 0.5

### us {} or not
if(z>0.8){cat(z, "is a large number", "\n")} else #cat means to call it that and then means a line space
  if(z<0.2){cat(z,"is a small number", "\n")} else
  {cat(z, "is a number of typical size", "\n")
    cat("z^2=", z^2, "\n")
    y <- T}
y


##### ifelse to fill vectors
### ifelse(condition, what you want if yes, what you want if no)

### insect population where females lay 10.2 eggs on average, follows a Poisson distribution (discrete probability distribution showing the likely number of times an event will occur). 35% parasitism where no eggs are laid. lets make a distribution for 1000 individuals
tester <- runif(1000)
eggs <- ifelse(tester>0.35, rpois(n=1000, lambda = 10.2), 0)
hist(eggs)

## vector of p-values from a simulation and we want to create a vector to highlight the significant ones for plotting
pVals <- runif(1000)
z <- ifelse(pVals <= 0.025, "lowerTail", "nonSig")
z
z[pVals >= 0.975] <- "upperTail"
table(z)


############ for loops
#### workhorse function for doing repetitive tasks
### universal in all computer languages
### controversial in R
### often necessary (vectorization in R)
### very slow with certain operations
### family of apply functions


##### Anatomy of a for loop
### for(variable in a squence){#starts the loop
#body of the for loop
#}
#var is a counter variable that holds the current value of the loop (i, j, k)
#sequence is an integer vector that defines start/end of loop

for(i in 1:5) {
  cat("stuck in a loop", i, "\n")
  cat(3+2, "\n")
  cat(3+i, "\n")
}
#1:5= how many times we want it to loop, i is whatever number we are in the sequnce
print(i)


### use a counter variable that maps to the position of each element
my_dogs <- c("chow", "akita", "malamute", "husky", "samoya")
for(i in 1:length(my_dogs)){
  cat("i=", i, "my_dogs[i]=", my_dogs[i], "\n")
}
  
### use double for loops
m <- matrix(round(runif(20), digits = 2), nrow=5)

for(i in 1:nrow(m)) {
  m[i,]<-m[i,] + i 
}
m

## loop over columns
m <- matrix(round(runif(20), digits = 2), nrow=5)
for(j in 1:nrow(m)) {
  m[,j]<-m[,j] + j 
}
m


#### loop over rows and columns **
m <- matrix(round(runif(20), digits = 2), nrow=5)

for(i in 1:nrow(m)) {
  for(j in 1:ncol(m)){
  m[i,j] <- m[i,j] + i + j 
  }
}
print(m)
