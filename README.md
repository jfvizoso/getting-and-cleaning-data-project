# getting-and-cleaning-data-project
Data Science coursera specialization by Johns Hopkins University. 
Getting and Cleaning Data course project.


This repository contains the R code and documentation for the course "Getting and Cleaning data".

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## Files

`CodeBook.md` describes the variables, the data, and any clean up process executed over the data.

`run_analysis.R` contains all the code to do the required tasks:

	1. Merges the training and the test sets to create one data set.
	2. Extracts only the measurements on the mean and standard deviation for each measurement. 
	3. Uses descriptive activity names to name the activities in the data set
	4. Appropriately labels the data set with descriptive variable names. 
	5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script will also download and uncompress the required dataset.
The output of `run_analysis.R` is a file called `meanData.txt`, that was also uploaded to the repository.

