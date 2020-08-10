getwd()
setwd("E:/R/Webscraping-in-R")
# 
# # Automated Web Scraping in R
# 
# # Let's start with a quick demonstration of scraping 
# # the main head and body text of a single web page 
# install.packages("rvest") #Uncomment this to install this package
# library(rvest)


#------------------------------------------------------------------------------------#
library(rvest)
Covid_table <- read_html("https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data#covid19-container")#Source : Wikipedia

tbl <- Covid_table %>%
  html_node("table#thetable.wikitable.plainrowheaders.sortable") #See HTML source code for data within this tag - mentioned in brackets

Covid_table <- read_html("https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data#covid19-container")

tbl <- Covid_table %>%
  html_node("table#thetable.wikitable.plainrowheaders.sortable") %>% #See HTML source code for data within this tag
  html_table(fill = TRUE)
tbl

Title <- Covid_table %>%
  html_node("title") %>% #See HTML source code for data within this tag - "title"
  html_text()
Title

#Data dimensions and Structure
  html_node("title") %>%
  html_text()
Title


dim(tbl)
str(tbl)
summary(tbl$`Cases[b]`)

#Creating backup of Data
tb2 <- tbl
tb2
summary(tb2)

#Selecting useful data i.e. Rows till where you have to take as there has been a paragraph beneath the table 
#which has been extraced along with the table.

tb3 <- tb2[1:229,]
tb3
dim(tb3)
tb3

Covid19_Table <- tb3[,-c(1,6)]
Covid19_Table
dimnames(Covid19_Table)
colnames(Covid19_Table)

#Removing "," from between the number figures in the following variables
#N2 <- gsub(",","",N1)
Cases <- gsub(",","",Covid19_Table$`Cases[b]`)
Deaths <- gsub(",","",Covid19_Table$`Deaths[c]`)
Recovered <- gsub(",","",Covid19_Table$`Recov.[d]`)
Location <- Covid19_Table$`Location[a]`

#Creating Data Frame (Pre-Processed) -Please see the values in Cases, Deaths and Recovered Variables
#are in character form but when I am trying to convert using as.numeric() it showing many NA values 
#So, this error I am facing from this website only but rest my purpose of webscraping is fulfilled.

Covid19_Tbl <- data.frame(Location,Cases,Deaths,Recovered)
Covid19_Tbl

#Data Exploration
Covid19_Tbl <- data.frame(Location,Cases,Deaths,Recovered)
Covid19_Tbl

library(sqldf)
Sq1 <- sqldf("Select Location,Cases
             from Covid19_Tbl")
Sq1

as.data.frame(colSums(is.na(Covid19_Tbl)))
View(Covid19_Tbl)

Sq2 <- sqldf("Select Location,Cases
             from Covid19_Tbl
             where Cases = 'No data'")
Sq2

Sq3 <- sqldf("Select *
             from Covid19_Tbl
             where Recovered = 'No data'")
Sq3


Covid19_Tbl[Covid19_Tbl == "No data"] <- "0"

Sq4 <- sqldf("Select Location,max(Recovered)
             from Covid19_Tbl")
Sq4


# Covid19_Tbl$Cases[is.na(Covid19_Tbl$Cases)] <- 0
# Covid19_Tbl <- Covid19_Tbl[1:228,]
# 
# World <- Covid19_Tbl[1,]
# Covid19_Tbl <- Covid19_Tbl[2:228,]


#Top 10 - Coronavirus Affected Countries Daily Updated
Covid_Top_10 <- Covid19_Tbl[2:11,]



#Email the result of Top 10 Coronavirus Affected Countries - Daily Updated
#install.packages('emayili')

library(emayili)
library(dplyr)

# email <- envelope() %>%
#   from("udmehra94@gmail.com") %>%
#   to("udmehra@live.com") %>%
#   subject("List of Top 10 Corona Affected Countries") %>%
#   text("Covid")
#   
#   
# smtp <- server(host = "smtp.gmail.com",
#                port = 587,
#                username = "udmehra94@gmail.com",
#                password = "ngrmwqilzjslxhay")
# smtp(email, verbose = TRUE)

write.csv(Covid_Top_10,file = "Covid_updates2020.csv",row.names = FALSE)


email <- envelope() %>%
  from("udmehra94@gmail.com") %>%
  to("udmehra@live.com") %>%
  subject("List of Top 10 Corona Affected Countries") %>%
  text("COVID-19 Pandemic data - PFA Document with this mail
       
               **Send from R**") %>%
  attachment("Covid_updates2020.csv")

smtp <- server(host = "smtp.gmail.com",
               port = 587,
               username = "ud*****94@gmail.com",
               password = "ngrmwqilzjslxhay") #Create R password from google - Settings - Accounts and Imports tab - 
                                          # Other Google Account settings - Click on Security option - Then App Password - 
                                          #Create R App password and use it here to get access of sending emails from R.

smtp(email, verbose = TRUE)

#For Sechduling time to automatically run the script daily we install these packages and mainly #taskscheduleR

smtp(email, verbose = TRUE)

# install.packages('data.table')
# install.packages('knitr')
# install.packages('miniUI')
# install.packages('shiny')
# install.packages("taskscheduleR", repos = "http://www.datatailor.be/rcube", type = 
#                   "source")

#------------------------------------------------------------#
# email <- envelope() %>%
#   from("udmehra94@gmail.com") %>%
#   to("udmehra@live.com") %>%
#   subject("List of Top 10 Corona Affected Countries") %>%
#   text("Covid")
#   
#   
# smtp <- server(host = "smtp.gmail.com",
#                port = 587,
#                username = "udmehra94@gmail.com",
#                password = "ngrmwqilzjslxhay")
# smtp(email, verbose = TRUE)
