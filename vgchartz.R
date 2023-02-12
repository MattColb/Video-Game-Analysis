rm(list=ls())
### Web Scraping ###
Start <- Sys.time()
library(xml2)
user_agent <- "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Mobile Safari/537.36"
#1249 Pages
all_sales <- data.frame()

# pages
# 1 - 250 (page went to 251, there will be duplicates) all_sales
# 251 - 400 all_sales_1
# 401 - 600 all_sales_2
# 601 - 800 all_sales_3
# 801 - 1000 all_sales_4
# 1001 - 1249 all_sales_5
# 1249 total pages

for (i in 1:3){
  
  print(i)
  
  url <- paste("https://www.vgchartz.com/games/games.php?page=", i, "&order=NASales&ownership=Both&direction=DESC&showtotalsales=1&shownasales=1&showpalsales=1&showjapansales=1&showothersales=1&showpublisher=1&showdeveloper=1&showreleasedate=1&showlastupdate=0&showvgchartzscore=0&showcriticscore=0&showuserscore=0&showshipped=0", sep='')
  #page <- read_html("https://www.vgchartz.com/games/games.php?page=1&order=NASales&ownership=Both&direction=DESC&showtotalsales=1&shownasales=1&showpalsales=1&showjapansales=1&showothersales=1&showpublisher=1&showdeveloper=1&showreleasedate=1&showlastupdate=0&showvgchartzscore=0&showcriticscore=0&showuserscore=0&showshipped=0")
  page <- read_html(url, user_agent)
  
  Sys.sleep(5)
  
  platform <- xml_attr(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[4]/img"), "alt")
  game <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[3]/a[1]"))
  publisher <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[5]"))
  NA_Sales <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[8]"))
  Total_Sales <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[7]"))
  PAL_Sales <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[9]"))
  JP_Sales <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[10]"))
  Other_Sales <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[11]"))
  Release_Date <- xml_text(xml_find_all(page, "//div[@id='generalBody']/table/tr/td[12]"))
  sales <- data.frame(game, platform, publisher, NA_Sales, Total_Sales, Release_Date, PAL_Sales, JP_Sales, Other_Sales)
  
  #all_sales <- rbind(all_sales, sales)
  all_sales <- rbind(all_sales, sales)
  
  rv <- sample(3:15, 1)
  Sys.sleep(rv)
}

write.csv(all_sales, "VGChartz_0.csv")
Stop <- Sys.time()
print(Start)
print(Stop)
print(Stop-Start)
