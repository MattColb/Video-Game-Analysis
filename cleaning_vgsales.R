rm(list=ls())
library(tidyverse)

#Read in the two data sets, setting the N/A strings to NA values
VGSales_union <- read.csv("VGSales_Union.csv", na.strings=c("N/A", "NA"))
VGSales_intersect <- read.csv("VGSales_Intersect.csv", na.strings=c("N/A", "NA"))

#Create a function to run over both datasets
cleaning_data <- function(df){
  #Trim white space of summary and publisher
  df$summary <- trimws(df$summary)
  df$publisher <- trimws(df$publisher)
  
  #Format the release date from metacritic to only have month and year
  df$release_date <- as.Date(df$release_date, format="%B %d, %Y")
  df$release_date <- format(df$release_date, "%B %Y")
  
  #Change the VGChartz release date to the month year format
  df$Release_Date <- gsub("th", "", df$Release_Date)
  df$Release_Date <- gsub("st", "", df$Release_Date)
  df$Release_Date <- gsub("nd", "", df$Release_Date)
  df$Release_Date <- gsub("rd", "", df$Release_Date)
  df$Release_Date <- as.Date(trimws(df$Release_Date), format="%d %b %y")
  df$Release_Date <- format(df$Release_Date, "%B %Y")
  
  #Turn the sales into integers and make it so that it is representative of millions
  df$NA_Sales <- as.numeric(str_replace(df$NA_Sales, "m", ""))*1000000
  df$Total_Sales <- as.numeric(str_replace(df$Total_Sales, "m", ""))*1000000
  
  #Use the metacritic release date as a base, and replace it with the VGChartz data if Metacritic is NA
  for (index in 1:nrow(df)){
    if(is.na(df$release_date[index])){
      df$release_date[index] <- df$Release_Date[index]
    }
  }
  
  #Set Games, Publisher, Platform as factors
  df$games <- factor(df$games)
  df$platform <- factor(df$platform)
  df$publisher <- factor(df$publisher)
  
  #Rename columns
  df <- df %>% rename(game_title = games, na_sales = NA_Sales, total_sales = Total_Sales)
  
  #drop unnecessary sales, indexes, and the VGChartz release date
  drop <- c("X", "X.1", "PAL_Sales", "JP_Sales", "Other_Sales", "Release_Date")
  df <- df[,!(names(df) %in% drop)]
}

#Print tables to show that there is no duplicated data in either
print(table(duplicated(VGSales_intersect)))
print(table(duplicated(VGSales_union)))

#Note that there are 4712 games without release dates in the union and none in the intersection
#table(is.na(VGSales_union$release_date))

#Run the function on both of the data sets
VGSales_intersect <- cleaning_data(VGSales_intersect)
VGSales_union <- cleaning_data(VGSales_union)

write.csv(VGSales_intersect, "VGSales_Intersect.csv")
write.csv(VGSales_union, "VGSales_Union.csv")