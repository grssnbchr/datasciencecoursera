download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "epc.zip", method = "curl")
unzip("epc.zip")
epc <- read.csv2('household_power_consumption.txt', sep=";", na.strings = "?", colClasses = "character")
head(epc)
epc$DateTime <- strptime(paste(epc$Date, epc$Time), "%d/%m/%Y %H:%M:%S")
epc_subset <- subset(epc, epc$Date == "1/2/2007" | epc$Date == "2/2/2007")

png("plot1.png")
hist(as.numeric(epc_subset$Global_active_power) , 
     col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()

png("plot2.png")
plot(epc_subset$DateTime, epc_subset$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l")
dev.off()