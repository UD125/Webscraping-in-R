getwd()
# 
# # Automated Web Scraping in R
# 
# # Let's start with a quick demonstration of scraping 
# # the main head and body text of a single web page 
# install.packages("rvest") #Uncomment this to install this package
# library(rvest)


#------------------------------------------------------------------------------------#
library(rvest)
Covid_table <- read_html("https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data#covid19-container")

tbl <- Covid_table %>%
  html_node("table#thetable.wikitable.plainrowheaders.sortable") %>% #See HTML source code for data within this tag
  html_table(fill = TRUE)
tbl

Title <- Covid_table %>%
  html_node("title") %>%
  html_text()
Title


dim(tbl)
str(tbl)
summary(tbl$`Cases[b]`)

tb2 <- tbl
tb2
summary(tb2)

tb3 <- tb2[1:229,]
tb3
dim(tb3)
tb3

Covid19_Table <- tb3[,-c(1,6)]
Covid19_Table
dimnames(Covid19_Table)
colnames(Covid19_Table)

#N2 <- gsub(",","",N1)
Cases <- gsub(",","",Covid19_Table$`Cases[b]`)
Deaths <- gsub(",","",Covid19_Table$`Deaths[c]`)
Recovered <- gsub(",","",Covid19_Table$`Recov.[d]`)
Location <- Covid19_Table$`Location[a]`

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
               password = "************")
smtp(email, verbose = TRUE)

# install.packages('data.table')
# install.packages('knitr')
# install.packages('miniUI')
# install.packages('shiny')
# install.packages("taskscheduleR", repos = "http://www.datatailor.be/rcube", type = 
#                   "source")
