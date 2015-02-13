install.packages("httr")
install.packages("httpuv")
install.packages("jsonlite")
library(httr)
library(httpuv)
library(jsonlite)
oauth_endpoints("github")
myapp <- oauth_app("github", "cf62ff65e919124398f6")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp, cache=F)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
response <- content(req)
beautifulResponse <- fromJSON(toJSON(response))
names(beautifulResponse)
beautifulResponse[beautifulResponse$name == "datasharing",c("created_at")]

# question 2 & 3
install.packages("sqldf")
library(sqldf)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "acs.csv", "curl")
acs <- read.csv("acs.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")

# question 4
library(XML)
nchar(readLines("http://biostat.jhsph.edu/~jleek/contact.html")[c(10,20,30,100)])

# question 5
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "wksst8110.for", "curl")
widths <- c(10,9,4,9)
columns <- c("Week", "Nino1+2 SST", "Nino1+2 SSTA", "Nino 3 SST")
wksst8110 <- read.fwf("wksst8110.for", skip = 4, widths = widths, col.names = columns)
sum(wksst8110[,4])
