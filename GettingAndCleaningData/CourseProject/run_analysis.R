download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "activity.zip", method = "curl")
unzip("activity.zip")
install.packages("data.table")
install.packages("reshape2")
library(data.table)
library(dplyr)
library(reshape2)
# extract data from files
test_set <- data.table(read.table("UCI HAR Dataset//test//X_test.txt"))
test_labels <- data.table(read.table("UCI HAR Dataset//test/y_test.txt"))
test_subjects <- data.table(read.table("UCI HAR Dataset//test/subject_test.txt"))
train_set <- data.table(read.table("UCI HAR Dataset//train/X_train.txt"))
train_labels <- data.table(read.table("UCI HAR Dataset//train/y_train.txt"))
train_subjects <- data.table(read.table("UCI HAR Dataset//train/subject_train.txt"))

# merge labels with features
test_set <- cbind(test_set, label = test_labels$V1)
train_set <- cbind(train_set, label = train_labels$V1)
# merge with subjects
test_set <- cbind(test_set, subject = test_subjects$V1)
train_set <- cbind(train_set, subject = train_subjects$V1)

# step 1
combined_set <- rbind(test_set, train_set)
# step 2
# read in features
feature_names <- read.csv("UCI HAR Dataset//features.txt", sep=" ", header = F, stringsAsFactors = F)
# step 3
names(combined_set) <- c(feature_names$V2, "label", "subject")
# extract columns with regular expressions - only extract those that are explicitly called mean() and std() at the end
colIndices <- c(grep("mean()",names(combined_set)), grep("std()",names(combined_set)), 562, 563)
# retain only these columns
combined_set <- select(combined_set, colIndices)
# step 4
# merge with activity description
activity_desc <- read.csv("UCI HAR Dataset//activity_labels.txt", sep = "", header = F, stringsAsFactors = F)
activity_desc <- rename(activity_desc, label = V1, label_text = V2)
combined_set <- merge(combined_set, activity_desc, by = "label")
# remove label column
combined_set <- combined_set[,label:=NULL]
# step 5: reshape
combined_set_tidy <- melt(combined_set, id = c("subject", "label_text"))
# aggregate
combined_set_tidy <- dcast(combined_set_tidy, subject + label_text ~ variable, mean)
# reshape to long format again
combined_set_tidy <- melt(combined_set_tidy, id = c("subject", "label_text"), variable.name = "measurement", value.name = "reading")
