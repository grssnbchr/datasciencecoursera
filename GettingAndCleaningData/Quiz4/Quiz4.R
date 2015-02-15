install.packages("stringr")
install.packages("magrittr")
install.packages("quantmod")
install.packages("lubridate")
library(stringr)
library(magrittr)
library(quantmod)
library(lubridate)
# question 1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "acs.csv", "curl")
acs <- read.csv("acs.csv")
strsplit(names(acs), "wgtp")[[123]]

# question 2
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv", "curl")
gdp <- read.csv("gdp.csv",  skip = 4, stringsAsFactors = F)

gdp <- gdp %>%
  select(c(X, X.1,X.3,X.4)) %>%
  rename(id = X, ranking = X.1, economy = X.3, millions = X.4) %>%
  filter(id != "" & ranking != "") %>%
  mutate(ranking = as.numeric(ranking))

mean(as.numeric(gsub(",", "", gdp$millions)))

# question 3
grep("^United", gdp$economy)

# question 4
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "edu.csv", "curl")
edu <- read.csv("edu.csv", stringsAsFactors = F)
edu$id <- edu$CountryCode
merged <- merge(gdp, edu, by = "id")
grep("Fiscal year end: June", merged$Special.Notes, value = T)

# question 5
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
yearIs2012 = year(sampleTimes) == 2012
table(yearIs2012)
table(yearIs2012, wday(sampleTimes, label = T) == "Mon")
