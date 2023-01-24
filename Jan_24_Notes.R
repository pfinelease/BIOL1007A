##### ggplot2
### 01/24/2023
###PFL 


library(ggplot2)
library(ggthemes)
library(patchwork)

### Template for ggplot code
##  p1 <- ggplot(data=<DATA>, mapping = aes(x = xVar, y = yVar)) + 
## <GEOM FUNCTION> ## geom_boxplot()
## print(p1)

#### load in a built-in data set
d <- mpg
str(d)

library(dplyr)
glimpse(d)

#### qplot : quick plotting not necessarily for publication
qplot(x=d$hwy)

qplot(x=d$hwy, fill= I("darkblue"), color= I("black")) 


## scatterplot
qplot(x= d$displ, y=d$hwy, geom=c("smooth", "point"), method = "lm")

# boxplot 
qplot(x=d$fl, y=d$cty, geom= "boxplot", fill=I("forestgreen"))

# barplot
qplot(x=d$fl, geom="bar", fill=I("forestgreen"))


### Create some data (specified counts)
x_trt <- c("control", "low", "high")
y_resp <- c(12, 2.5, 22.9)
qplot(x=x_trt, y=y_resp, geom="col", fill=I(c("forestgreen", "slategray", "goldenrod")))


##### ggplot : uses data frames instead of vectors
p1 <- ggplot(data=d, mapping=aes(x=displ, y=cty, color=cyl)) +
  geom_point()
p1

p1 + theme_base()
p1 + theme_bw()
p1 + theme_classic()
p1 + theme_linedraw()
p1 + theme_dark()
p1 + theme_minimal()
p1 + theme_void()
p1 + theme_economist()

p1 + theme_bw(base_size=20, base_family = "serif")

p2 <- ggplot(data=d, aes(x=fl, fill=fl)) +
  geom_bar()
p2 + coord_flip() + theme_classic(base_size = 15, base_family = "sans")


# Theme modifications
p3 <- ggplot(data = d, aes(x=displ, y=cty)) + 
  geom_point(size=4, shape=21, color="magenta", fill="black") + 
  xlab("Count") + 
  ylab("Fuel") +
  labs(title= "My title here", subtitle = "my subtitle goes here") #x= and y= for axis as well
p3
p3 + xlim(1,10) + ylim(0,35)

library(viridisLite)
cols <- viridis(7, option="magma") #options include plasma, turbo, viridis
ggplot(data=d, aes(x=cyl, y=hwy, fill=class)) + 
  geom_boxplot() + 
  scale_fill_manual(values=cols) #if there are errors, look for differences in variable names that you typed in

library(patchwork)
p1 + p2 + p3
p1 / p2 / p3
(p1 + p2) / p3
q