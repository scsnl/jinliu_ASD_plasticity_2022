#clear workspace####
rm(list=ls())

#package loading function####
load.packages <- function(package.list){ 
new.packages <- package.list[!(package.list %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
for (i in 1:length(package.list)){
library(package.list[i],character.only=TRUE)
}
}

#load packages, install if needed####
package.list <- c("lavaan", "semPlot", "mediation")
load.packages(package.list)

#load data set
data<-read.csv("~/Documents/projects/2019_Whiz/mediation/data_whizz new2.csv")

# function for centering variables
center.var <- function(x){
  centered <- as.vector(scale(x = x, center = TRUE,
                              scale = FALSE))
  return(centered)
}

#moderation
Insistence.on.Sameness <- data$Insistence.on.Sameness #Circumscribed.Interests #Insistence.on.Sameness # Circumscribed.Interests #
prepostRSA.L.aparaHipp <- data$NRP.L.pPHG # data$NRP.R.IPS
Acc.gains <- data$Acc.gain
data.short <- data.frame(Insistence.on.Sameness, prepostRSA.L.aparaHipp, Acc.gains)

sink(file="~/Documents/projects/2019_Whiz/mediation/moderation.txt")
linfit<-lm(scale(Acc.gains)~scale(Insistence.on.Sameness)*scale(prepostRSA.L.aparaHipp),data=data)
print(summary(linfit))
sink()