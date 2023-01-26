##### Lecture 8 : Loading in Data
####PFL
#### 1/26/2023

#Create and save a dataset
### write.table(x=varname, file="outputFileName.csv, header=T, sep=",")


# These functions read in a data set
##read.table(file="path/to/data.csv", header=T, sep = ",")
#read.csv(file="data.csv", header=T)


# Use RDS object when only working in R
## saveRDS(my_data, file="FileName.RDS) #helpful with large data sets; put RDS after filename
## readRDS("FileName.RDS")
### p<- readRDS("FileName.RDS") #now p will be that file


# Long vs Wide data formats (wide has more columns than rows) (long has more rows than columns) 
## Wide format contains volues that DO NOT repeat in the ID column
## long format contains values the DO repear in the ID column

library(tidyverse)
glimpse(billboard)
# 317 rows and 79 columns so this is a wide data format
b1 <- billboard %>%
  pivot_longer(
    cols = starts_with("wk"), #specifies which columns you want to make longer
    names_to = "Week", #name of the new column which will contain the header names
    values_to = "Rank" #name of the new column which will contain the values
    values_drop_na = T #removes any rows where the value = NA
  )
view(b1)


# pivot_wider
## beest for making occupancy matrix
glimpse(fish_encounters) #more rows than columns = long
view(fish_encounters) #given a value of 1 if seen at the location

fish_encounters %>% 
  pivot_wider(names_from = station, #which column you want to turn into multiple columns
              values_from = seen) #which column containes the values for the new columns

fish_encounters %>% 
  pivot_wider(names_from = station,
              values_from = seen,
              values_fill = 0) #this turned the NAs into 0s

# Dryad: makes reasearch data freely reusable, citable, and discoverable

#read.table()
dryadData <- read.table(file = "Data/veysey:babbit_data_amphibians.csv", header = T, sep = ",")
glimpse(dryadData)
head(dryadData)
view(dryadData)
table(dryadData$species) # allows you to see different groups of character column
summary(dryadData$mean.hydro)

str(dryadData$species)


dryadData$species<-factor(dryadData$species, labels=c("Spotted Salamander", "Wood Frog")) #creating 'labels' to use for the plot; first "" goes on the first plot
str(dryadData$species)
#class(dryadData$treatment)
dryadData$treatment <- factor(dryadData$treatment, 
                              levels=c("Reference",
                                       "100m", "30m")) #gives the labels for the x axis; levels changes the orders for the groups; it appears as though nothing changes without the levels argument


p<- ggplot(data=dryadData, # this is stating that we are using dryad data 
           aes(x=interaction(wetland, treatment), #this is mapping the variables for each axis; groups wetland and treatment as group
               y=count.total.adults, fill=factor(year))) + geom_bar(position="dodge", stat="identity", color="black")  + #without fill=factor(year), it seems like some data is deleted. The data stacks and turns all into one counting the adults for each area for y axis; without position=data, the data is stacked; without stat=identity, the code will not run; here, the color determines the outlining of each bar; geom_bar states that it is a bar graph
  ylab("Number of breeding adults") + # labeling y axis 
  xlab("") + #by leaving this blank, there is no x label
  scale_y_continuous(breaks = c(0,100,200,300,400,500)) + #y axis should be broke up by 100s; changing this will change the numerical inputs on the
  scale_x_discrete(labels=c("30 (Ref)", "124 (Ref)", "141 (Ref)", "25 (100m)","39 (100m)","55 (100m)","129 (100m)", "7 (30m)","19 (30m)","20 (30m)","59 (30m)")) + #this is labeling each specific x position
  facet_wrap(~species, nrow=2, strip.position="right") + #indicates that species is what we are referencing; facet_wrap wraps 1 dimensional into 2 dimensional; nrow=2 makes 2 rows of graphs; when it is = 1, the graphs go side by side. anything other than 2 puts them side by side; strip.position changes the side of "Spotted Salamander" and "Wood Frog"
  theme_few() + scale_fill_grey() + #nothing appears to change without theme_few(). changing the value in the () changes the font size of the numbers; without scale_fill_grey, the fill color inside of the bars become colorful 
  theme(panel.background = element_rect(fill = 'gray94', color = 'black'), legend.position="top",  legend.title= element_blank(), axis.title.y = element_text(size=12, face="bold", colour = "black"), strip.text.y = element_text(size = 10, face="bold", colour = "black")) + 
  guides(fill=guide_legend(nrow=1,byrow=T)) 
#changing fill color changes the background color; legend position puts the legend on the top; leaving element_blank gives the legend no title; the size and face change the text size and structure on the side labels; nrow changes the amount of rows of the legend
p
