require(stringr)
pollutantmean <- function(directory, pollutant, id = 1:332) {
  data <- data.frame()
  i <- 0
  for(csvid in id){
    csv <- read.csv(paste(directory, "/", str_pad(csvid, 3, pad = "0"), ".csv", sep = ""))
    if(i == 0) {
      data <- csv
    } else {
      data <- rbind(data, csv)
    }
    i <- i + 1
  }
  mean(data[, pollutant], na.rm = T)
}
