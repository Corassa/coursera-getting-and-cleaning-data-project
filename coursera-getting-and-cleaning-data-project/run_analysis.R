library(plyr)

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# 1 -  Merges the training and the test sets to create one data set.
dataset <- rbind(X_test, X_train)

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt")

mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])
dataset <- dataset[, mean_and_std]
names(dataset) <- features[mean_and_std, 2]

# 3 - Uses descriptive activity names to name the activities in the data set
activity <- read.table('UCI HAR Dataset/activity_labels.txt')
#read y datasets
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_dataset <- rbind(y_test,y_train)
#upadate with activity
y_dataset[, 1] <- activity[y_dataset[, 1], 2]
#attribute the name
names(y_dataset) <- "activity"

# 4 - Appropriately labels the data set with descriptive variable names.
dataset <- cbind(dataset, y_dataset, subject)

# 5 - From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
data_final <- ddply(dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(data_final, "tidy.txt", row.name=FALSE)

