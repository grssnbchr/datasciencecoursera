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

# add labels to features
test_set <- cbind(test_set, label = test_labels$V1)
train_set <- cbind(train_set, label = train_labels$V1)

# add subjects
test_set <- cbind(test_set, subject = test_subjects$V1)
train_set <- cbind(train_set, subject = train_subjects$V1)

# step 1
combined_set <- rbind(test_set, train_set)

# step 2 & 3
# read in features
feature_names <- read.csv("UCI HAR Dataset//features.txt", sep=" ", header = F, stringsAsFactors = F)
# correctly name every feature in the set produced in step 1, including the last two columns
names(combined_set) <- c(feature_names$V2, "label", "subject")
# extract columns with regular expressions - only extract those that are explicitly called mean() and std() at the end
# also retain two last columns as they contain label and subject
colIndices <- c(grep("mean()",names(combined_set)), grep("std()", names(combined_set)), 562, 563)
# retain only these columns
combined_set <- select(combined_set, colIndices)

# step 4
# join with activity description
activity_desc <- read.csv("UCI HAR Dataset//activity_labels.txt", sep = "", header = F, stringsAsFactors = F)
# using dplyr's rename 
activity_desc <- rename(activity_desc, label = V1, label_text = V2)
# join by "label"
combined_set <- merge(combined_set, activity_desc, by = "label")
# remove label column (again with dplyr)
combined_set <- select(combined_set, -label)

# before reshaping and aggregating, do some plausibility checks
# check if every subject performed all 6 activities
table(sapply(tapply(combined_set$label_text, combined_set$subject, unique), length) == 6)
# okay, it seems that every of the thirty subjects performed all 6 different activities, 
# which gives 6 * 30 = 180 subject/activity combinations

# step 5: reshape
combined_set_long <- melt(combined_set, id = c("subject", "label_text"))
# aggregate, for every subject/activity combination, calculate the mean of all measurements
combined_set_wide <- dcast(combined_set_long, subject + label_text ~ variable, mean)

# reshape to long format again
combined_set_long <- melt(combined_set_wide, id = c("subject", "label_text"), variable.name = "measurement", value.name = "reading")
# plausibility check: 6 subjects times 30 activities times 79 measurements should equal 14220 readings in total
6 * 30 * 79 == dim(combined_set_long)[1]

# write out to file
write.table(combined_set_long, "tidy_data.txt", row.names = F)
