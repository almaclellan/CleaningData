## A script to:
##Here are the data for the project: 
##  
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
##You should create one R script called run_analysis.R that does the following. 
##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive activity names. 
##5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##Good luck!

features <- read.table("UCI HAR Dataset/features.txt") # get features

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt") # get activity labels
meanVectorN<-grep("mean\\(\\)", features$V2) # get the column numbers of the means
meanVector<-grep("mean\\(\\)", features$V2, value=TRUE) # get the values of the means
stdVectorN<-grep("std\\(\\)", features$V2) # get the column numbers of the std deviation
stdVector<-grep("std\\(\\)", features$V2, value=TRUE) # get the columna names values of the std deviation
extraColumns<-c("subject","activity")


#Change the column names to descriptive name


# Process the Training data

xTrain <- read.table("UCI HAR Dataset/train/X_train.txt") #7352
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt") #7352 Activity
colnames(xTrain) <-features$V2 # features
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subjectTrain)<-"subject"
colnames(yTrain)<-"activity"
Train <- cbind(xTrain, subjectTrain, yTrain)

# Process the Test data

xTest <- read.table("UCI HAR Dataset/test/X_test.txt") #2947
yTest <- read.table("UCI HAR Dataset/test/y_test.txt") #2947 Activity
colnames(xTest) <- features$V2 #features 
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(subjectTest)<-"subject"
colnames(yTest)<-"activity"
Test <- cbind(xTest, subjectTest, yTest)

# Put the data into one dataset
oneSet <- rbind(Train, Test)
colnames(oneSet) <-colnames(Train)

# Put the values from the columns where the names match the values
# in the meanVector, stdVector and Subject

selectedColumns <- oneSet[c(meanVector,stdVector,extraColumns)]
selectedColumnsNames <-colnames(selectedColumns)

selectedColumnsNames <- gsub("^f", "fastfouriertransform", selectedColumnsNames)
selectedColumnsNames <- gsub("^t", "total", selectedColumnsNames)
selectedColumnsNames <- gsub("Body", "body", selectedColumnsNames)
selectedColumnsNames <- gsub("Gyro", "gyroscope", selectedColumnsNames)
selectedColumnsNames <- gsub("Acc", "accelerometer", selectedColumnsNames)
selectedColumnsNames <- gsub("Jerk", "jerk", selectedColumnsNames)
selectedColumnsNames <- gsub("Mag", "mag", selectedColumnsNames)
selectedColumnsNames <- gsub("Gravity", "gravityaccelerometer", selectedColumnsNames)
selectedColumnsNames <- gsub("\\-X", "\\-x", selectedColumnsNames)
selectedColumnsNames <- gsub("\\-Y", "\\-y", selectedColumnsNames)
selectedColumnsNames <- gsub("\\-Z", "\\-z", selectedColumnsNames)
selectedColumnsNames <- gsub("\\-", "", selectedColumnsNames)
selectedColumnsNames <- gsub("std\\(\\)", "standarddeviation", selectedColumnsNames)
selectedColumnsNames <- gsub("mean\\(\\)", "mean", selectedColumnsNames)
colnames(selectedColumns) <- selectedColumnsNames

dfSelectedColumns <-data.frame(selectedColumns)

avgs <- aggregate(dfSelectedColumns, list(dfSelectedColumns$subject, dfSelectedColumns$activity), mean, na.rm=TRUE)

key <- data.frame(activityLabels)
colnames(key) <- c("activity","activityvalue")

# Merge the activity 

avgs <- merge(avgs, key, by="activity")

#Remove columns
avgs$Group.1 <- NULL
avgs$Group.2 <- NULL
avgs$activity <- NULL

# Write the file

write.csv(avgs, file="tidyHARData.csv")
