corr <- function(directory, threshold = 0) {
  corr <- vector()
  for(csvid in list.files(directory)){
    csv <- read.csv(paste(directory, "/", csvid, sep = ""))
    nobs <- table(complete.cases(csv))[2]
    if(is.na(nobs)){
      nobs = 0
    }
    if(nobs > threshold){
      csv <- csv[complete.cases(csv),]
      corr <- c(corr, cor(x = csv[,"nitrate"], y = csv[,"sulfate"]))
    }
  }
  as.numeric(corr)
}