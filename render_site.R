##########----------##########----------##########----------##########----------

##########---------- HEADER

##### meta-information
## Author: Hardika Dayalani (dayalani@rand.org)
## Creation: 2020-02-25 for Research Poster Presentation 
## Description: Renderes site for github pages

##### environment set up
remove( list= objects() )

##### Load Libraries
library(rmarkdown)

##### Set Working Directory
setwd("./dissertation-poster")

##### Render Site
render_site()
