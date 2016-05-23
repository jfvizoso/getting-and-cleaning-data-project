library(reshape2)
library(plyr)

## Download file
filename <- "dataset.zip" 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", filename);
unzip(filename)  

## Extracts only the measurements on the mean and standard deviation for each measurement. 

# Get indexes of the desired measured for later use
features <- read.table("./UCI HAR Dataset/features.txt")
selectedFeatureIndexes <- grep(".*mean.*|.*std.*", features[,2])

# read files, note that we only extract the selected measures from X_train.txt and X_test.txt
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")[selectedFeatureIndexes]
trainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")[selectedFeatureIndexes]
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Merges the training and the test sets to create one data set
train <- cbind(trainX, trainSubject, trainY)
test <- cbind(testX, testSubject, testY)
data <- rbind(train, test)

## Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
data$Activity <- factor(data$Activity, levels = activityLabels[,1], labels = activityLabels[,2])

## Appropriately labels the data set with descriptive variable names. 
columnNames <- features[selectedFeatureIndexes,2]
columnNames <- gsub('-mean', 'Mean', columnNames) 
columnNames <- gsub('-std', 'Std', columnNames) 
columnNames <- gsub('[-()]', '', columnNames) 
columnNames <- c (columnNames, "Subject", "Activity")
names(data) <- columnNames


## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
# calculate means for all columns except 2 (Subject and Activity)
lastColumn <- dim(data)[2]-2
meanData <- ddply(data, .(Subject, Activity), function(x) colMeans(x[, 1:lastColumn]))
write.table(meanData, "meanData.txt", row.names = FALSE, quote = FALSE)

