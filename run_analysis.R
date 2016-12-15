library(plyr)
setwd("~/Desktop/Data Analytics Course era/Getting and Cleaning Data/UCI HAR Dataset")
# Step 1

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# creating datasets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 2

features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2]) # extrating columns which has their names only as mean or std
x_data <- x_data[, mean_and_std_features]                 # subsetting the desired columns
names(x_data) <- features[mean_and_std_features, 2]       # to correct the column names

# Step 3

activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]   # correcting the activity names with update values
names(y_data) <- "activity"                 # column names corrected

# Step 4
names(subject_data) <- "subject"  # sub column name correction
all_data <- cbind(x_data, y_data, subject_data)  # creating a single data set by binding all the columns

# Step 5
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66])) # Act and sub cols

write.table(averages_data, "averages_data.txt", row.name=FALSE)
