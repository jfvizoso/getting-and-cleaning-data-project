# Code Book

This document details the steps made on run_analysis.R to create a tidy dataset with the mean of the required variables of the original dataset provided.

## Libraries
Two third-party libraries has been used on the code.

	library(reshape2)
	library(plyr)

## Download an uncompress file
First thing the script do is to download the source dataset to a file named "dataset.zip" and then uncompress the file.
The file contents will then be available on the folder ./UCI HAR Dataset

	filename <- "dataset.zip" 
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", filename);
	unzip(filename)  


## Extracts only the measurements on the mean and standard deviation for each measurement. 
This was the second step of the project list of 5, but I made this one the first so the data is filtered on the moment I read it from the files

Get indexes of the desired measured for later use
Read the features.txt file and get the indexes of the features that I will use (mean and std). I use grep here to get the indexes.

	features <- read.table("./UCI HAR Dataset/features.txt")
	selectedFeatureIndexes <- grep(".*mean.*|.*std.*", features[,2])

Read files, note that I only extract the selected measures from X_train.txt and X_test.txt

	trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")[selectedFeatureIndexes]
	trainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
	trainSubject<- read.table("./UCI HAR Dataset/train/subject_train.txt")
	testX <- read.table("./UCI HAR Dataset/test/X_test.txt")[selectedFeatureIndexes]
	testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
	testSubject<- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Merges the training and the test sets to create one data set
I made now the first step on the list, merge the datasets to create a unique one.
First I merge the columns, X (features), Subject and Y (activity)
Then I merge train and test datasets

	train <- cbind(trainX, trainSubject, trainY)
	test <- cbind(testX, testSubject, testY)
	data <- rbind(train, test)


## Uses descriptive activity names to name the activities in the data set
3rd step on the list.
Use the labels in activity_labels.txt to convert the Activity column to a factor

	activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
	data$Activity <- factor(data$Activity, levels = activityLabels[,1], labels = activityLabels[,2])


## Appropriately labels the data set with descriptive variable names. 
This is the 4th step.
Remove unwanted characters and capitalize mean and std
Add Subject and Activity to the list and set the names of the columns

	columnNames <- features[selectedFeatureIndexes,2]
	columnNames <- gsub('-mean', 'Mean', columnNames) 
	columnNames <- gsub('-std', 'Std', columnNames) 
	columnNames <- gsub('[-()]', '', columnNames) 
	columnNames <- c (columnNames, "Subject", "Activity")
	names(data) <- columnNames


## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
Last step on the list

Calculate means for all columns except the last 2 (Subject and Activity)
	
	lastColumn <- dim(data)[2]-2
	meanData <- ddply(data, .(Subject, Activity), function(x) colMeans(x[, 1:lastColumn]))
	write.table(meanData, "meanData.txt", row.names = FALSE, quote = FALSE)
