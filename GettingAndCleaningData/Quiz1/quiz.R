# question 1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "acs.csv", "curl")
# other stuff

# question 3
install.packages("rJava")
install.packages("xlsx")

library(xlsx)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "nga.xlsx", "curl")

install.packages("XML")

library(XML)

library(data.table)
DT <- fread("microdata.csv")
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})
system.time(tapply(DT$pwgtp15,DT$SEX,mean))

iterate <- function(){
  for(i in 1:100){
    mean <- DT[,mean(pwgtp15),by=SEX]
  }
}
system.time(iterate())
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

system.time(tapply(DT$pwgtp15,DT$SEX,mean))