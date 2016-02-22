## @header     Course Project for Getting and Cleaning Data 
## @abstract   The purpose of this project is to demonstrate ability to collect, work with, and clean
##             a data set. The goal is to prepare tidy data that can be used for later analysis.
## @evironment Windows10 x64-w64-mingw32,R version 3.2.3 (2015-12-10)
## @author     Chen Xu
## @date       2016-02-22


# 1.Download and unzip the file
if(!file.exists("Cousera_Dataset")){
    dir.create("Cousera_Dataset")
}
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  destfile = "./Cousera_Dataset/projectDataset.zip")
    unzip("./Cousera_Dataset/projectDataset.zip")

# 2.Load in the targeted datasets 

# 2.1 Load in the subject/activity datasets (test & train datasets)
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "id")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "id")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")

# 2.2 Load in the activity labels & features  
actLabel <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                       col.names = c("activityNumber", "activity"))
colName <- read.table("./UCI HAR Dataset/features.txt", check.names = FALSE)

# 2.3 Load in train/test dataset
train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                    colClasses = rep("numeric", 561),
                    col.names = colName[[2]], check.names = FALSE)
test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                   colClasses = rep("numeric", 561),
                   col.names = colName[[2]], check.names = FALSE)

# 3.Process the datasets (Project Requirements)

# 3.1 Merge the training and the test sets to create one data set.
# Combine the test dataset
allTest <- cbind(testSubject,testActivity,test)
# Combine the train dataset
allTrain <- cbind(trainSubject,trainActivity,train)
# Combine to a dataset
allData <- rbind(allTrain,allTest)

# 3.2 Extract only the measurements on the mean and standard deviation for each measurement. 

# Find all column/variable that contain "mean" or "std"
meanAndStd <- grep("mean|std", colName[[2]])
# Extract the measurements on mean and standard deviation
allData <- allData[,meanAndStd]


# 3.3 Use descriptive activity names to name the activities in the data set

allData$activity <- actLabel[match(allData$activity,actLabel[[1]]),2]


# 3.4 Appropriately labels the data set with descriptive variable names. 

# get names of all variables 
varName <- names(allData)

# abbreviated strings in varName
abbr <- c("^f", "^t", "Acc", "-mean\\(\\)", "-meanFreq\\(\\)", "-std\\(\\)", "Gyro", "Mag", "BodyBody")

# Appropriated strings 
appro <- c("freq", "time", "Acceleration", "Mean", "MeanFrequency", "Std", "Gyroscope", "Magnitude", 
               "Body")

# replace each abbreviated string with the corrected one
for(i in seq_along(abbr)){
    varName <- sub(abbr[i], appro[i], varName)
}

# replace column names of allData with corrected version
names(allData) <- varName

# 3.5 Creates a tidy data set with the average of each variable for each activity and each subject

# create independent data set with average for each variable/activity/subject
newData <- aggregate(allData[, 3:length(allData)], 
                     list(activity = allData$activity, id = allData$id), 
                     mean)

# write newData to output file
write.table(newData, file = "HAR_Tidy_Averages_DataSet.txt", row.name = FALSE)