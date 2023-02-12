rm(list=ls())
library(tidyverse)
setwd("./VGChartz")
VGChartz = list()
#Dictionary to convert Metacritics full platform names to VGChartz abbreviations
platform_dict = c("Game Boy Advance"="GBA", "DS"="DS", "PSP"="PSP", "Xbox One"="XOne", "Switch"="NS", 
                  "PlayStation 4"="PS4", "Wii U"="WiiU", "Xbox 360"="X360", "GameCube"="GC", 
                  "PlayStation"="PS", "Xbox Series X"="XS", "PlayStation 3"="PS3", "Dreamcast"="DC", "PlayStation 2"="PS2",
                  "PC"="PC", "PlayStation 5"="PS5", "Wii"="Wii", "Xbox"="XB", 
                  "Nintendo 64"="N64", "PlayStation Vita"="PSV", "3DS"="3DS", "Stadia"="PC")
#Import all pages into a list
for (i in 0:5){
  curr_page <- paste("VGChartz_", as.character(i), ".csv", sep="")
  inter <- read.csv(curr_page)
  VGChartz[[i+1]] <- inter
}
#Create a sales data frame and row bind all of the data frames in the list to the sales data frame
sales <- data.frame()
for (n in 1:6){
  sales <- rbind(sales, VGChartz[[n]])
}
#create a new variable called games, which is the game name and aligns with Metacritic
sales$games <- trimws(sales$game)
#drop index and game column
drop <- c("X", "game")
sales <- sales[,!(names(sales) %in% drop)]
#Get the distinct values of sales
sales <- distinct(sales)
#Import Metacritic data
setwd("..")
Metacritic <- read.csv("Metacritic.csv")
#Make Metacritic's platform data look like VGChartz
Metacritic$platform <- platform_dict[trimws(Metacritic$platform)]

#Merge the sales and Metacritic data and only keep the values that appear in both
intersection <- merge(sales, Metacritic, by=c("games", "platform"))
#Merge sales and Metacritic data with all of the data preserved.
union <- merge(sales, Metacritic, by=c("games", "platform"), all=TRUE)
union <- arrange(union, desc(user_score), Total_Sales)
#Write them to their own separate files.
write.csv(union, "VGSales_Union.csv")
write.csv(intersection, "VGSales_Intersect.csv")