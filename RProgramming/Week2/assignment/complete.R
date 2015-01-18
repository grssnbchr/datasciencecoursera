complete <- function(directory, id = 1:332) {
  data <- data.frame(id = NA, nobs = NA)
  i <- 1
  for(csvid in id){
    csv <- read.csv(paste(directory, "/", str_pad(csvid, 3, pad = "0"), ".csv", sep = ""))
    data[i,] <- c(csvid, table(complete.cases(csv))[2])
    i <- i + 1
  }
  data
}

