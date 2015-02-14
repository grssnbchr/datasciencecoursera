# question 1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "acs.csv", "curl")
acs <- read.csv("acs.csv")
logicalVector <- acs$ACR == 3 & acs$AGS == 6
which(logicalVector)[1:3]
# question 2
install.packages("jpeg")
library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "jeff.jpeg", "curl")
jeffRaster <- readJPEG("jeff.jpeg", native = T)
quantile(jeffRaster, c(0.3,0.8))
# question 3
install.packages("dplyr")
library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv", "curl")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "edu.csv", "curl")
gdp <- read.csv("gdp.csv",  skip = 4, stringsAsFactors = F)
gdp <- gdp %>%
  select(c(X, X.1,X.3,X.4)) %>%
  rename(id = X, ranking = X.1, economy = X.3, millions = X.4) %>%
  select(c(id, ranking)) %>%
  filter(id != "" & ranking != "") %>%
  mutate(ranking = as.numeric(ranking))
edu <- read.csv("edu.csv", stringsAsFactors = F)
edu <- edu %>%
  rename(id = CountryCode) %>%
  select(c(id, Long.Name, Income.Group))
merged <- merge(gdp, edu, by = "id") %>%
  arrange(desc(ranking))
merged %>%
  select(Long.Name) %>%
  filter(row_number() == 13)
# question 4
merged %>%
  group_by(Income.Group) %>%
  summarise(avg.ranking = mean(ranking))
# question 5
table(merged$Income.Group, cut(merged$ranking, quantile(merged$ranking,probs=c(0, 0.2,0.4,0.6,0.8, 1))))
