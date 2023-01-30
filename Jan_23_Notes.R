### Entering the Tidyverse(dplyr)
## 01/23/2023
#PFL

#tidyverse: collection of packages that share philosophy, grammar (or how the code is structured), and data structures

#operators: symbols that tell R to perform opeartions (between vairables. functions, etc)
## ex: arithmetic operators: + -m * / ^ ~
## assignment operator: <- 
## logical operators: ! (not), &, | (or)
## Relational operators: ==, != (does not equal), >, <, <=, >=
## Miscellaneos operators, %>%,  (Forward pipe operator) %in%
library(tidyverse) #library function to load in packages

# dplyr: new(er) package that proves a set of tools for manipulating data sets
# individual functions that correspond to common operations

## the core verbs
# filter()
# arrange()
# select()
# group_by() and summarize()
# mutate()  creates new variables only within our dataframe

##built in data set
data(starwars)
class(starwars)

# tibble (tbl) : modern take on data frames
# keeps great aspects of data frames and drops frustrating ones (changes variables)

glimpse(starwars) #much more clean than str(starwars)

### NAs 
anyNA(starwars) # is.na #complete.cases
starwarsClean <- starwars[complete.cases(starwars[,1:10]),]
glimpse(starwarsClean)
anyNA(starwarsClean[,1:10])
 #we have erased NAs in the first ten columns

#filter() : picks/subsets observations (ROWS) by their values

filter(starwarsClean, gender=="masculine" & height <180) # , means &
filter(starwarsClean, gender=="masculine", height <180, height > 100) #multiple conditions for the same variable 

filter(starwarsClean, gender=="masculine" | gender == "feminine")


### %in% operator (matching); similar to == but you can compare vectors of different lengths
# sequence of letters

a<- LETTERS[1:10]
length(a)

b <- LETTERS[4:10]
length(b)

##output of %in% depends on first vector
a %in% b #is saying whether the values in a exhist in b

b %in% a # all of the elements in b exhist in a

#use  %in%  to subset
eyes<- filter(starwars, eye_color %in% c("blue", "brown"))
view(eyes)

## arrange() : reorders rows
arrange(starwarsClean, by=height)
#default is ascneding order
#can use helper function desc() to get descending order
arrange(starwarsClean, by=desc(height))

arrange(starwarsClean, height, desc(mass)) # the second variable used will break ties; will list the heaviest and then the lighter one

sw <- arrange(starwars, by=height)
tail(sw) #missing values are at the end 


### select() : chooses variables (columns) by their names
select(starwarsClean, 1:11)
select(starwarsClean, name:species) #gives us data up until species column
select(starwarsClean, -(films:starships))
starwarsClean[, 1:11]
## all of these do the same thing: we are learning to not include certain columns

### Rearrange columns
select(starwarsClean, name, gender, species, everything()) #puts everything after the columns that we listed/wanted to view; everything() is a helper functuion that is useful if you have a couple variables that you want to move to the beginning

# contains() helper function
select(starwarsClean, contains("color")) #others include ends_with(), starts_with(), num_range()

#select can also rename columns
select(starwarsClean, haircolor = hair_color) #we changed the original column names hair_color to haircolor: returns only renamed column; can use everything() to return the whole list with haircolor first
rename(starwarsClean, haircolor = hair_color) #renames the entire dataframe

### mutate() : creates new variables using functions of existing variables
#lets create a new volumn that is height divided by mass
mutate(starwarsClean, ratio= height/mass)
 starwars_lbs <- (mutate(starwarsClean, mass_lbs = mass*2.2))
starwars_lbs <- select(starwars_lbs, 1:3, mass_lbs, everything()) #brought this to the front using select
glimpse(starwars_lbs) 

##transmute 
transmute(starwarsClean, mass_lbs = mass*2.2, .after=mass) #only returns mutated columns
transmute(starwarsClean, name, mass, mass_lbs=mass*2.2, height)


## group_by() and summarize()
summarize(starwarsClean, mean_height = mean(height)) #throws NA if any NAs are in dr; need to use na.rm

summarize(starwarsClean, mean_height = mean(height), TotalNumber = n()) #tells us the amount of data points in the calculation

# use group_by for maximum usefulness
starwars_genders <- group_by(starwars, gender)
head(starwars_genders)

summarize(starwars_genders, mean_height = mean(height, na.rm=T), TotalNumber = n())


##### Piping %>% pipes the output of one function into the input of the next; used to emphasize a sequence of actions ; allows you to pass an intermediate resuslt onto the next function (uses output of one function as unnput of the nect function); avoid if you need to manipulate more than one object at a time; or if you have meaningful intermediate variables that you want to go back to/save/use later
### Formatting: should have a space before the %>% followed by a new line

starwarsClean %>%
  group_by(gender) %>%
  summarize(mean_height = mean(height, na.rm=T), TotalNumber=n()) # na.rm=T skips NAs ; this function is much cleaner with piping

# case_when() is useful for multiple if/ifelse statements 
starwarsClean %>%
  mutate(sp = case_when(species=="Human" ~ "Human", T ~ "Non-Human")) # uses condition, puts "Human" if True in sp column, puts "Non ~Human" if it is False


