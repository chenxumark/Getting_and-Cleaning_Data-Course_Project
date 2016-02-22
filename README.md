# Course Project: Getting and Cleaning Data Course

##1.Introduction
The original dataset of this project is the **Human Activity Recognition Using Smartphones Dataset** from the UCI Machine Learning. The dataset is collected through six different daily activities pattern among 30 subjects.
The six activities are:

- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING

The full description can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and the dataset can be manually downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). However, the script automatically downloads the data directory so there's no need to manually download it.
The [Github](https://github.com/chenxumark/Getting_and-Cleaning_Data-Course_Project) included the 4 files related to the project

- `README.md` - this file providing the introduction of the project and dataset processing

- `Codebook.md` - demonstrates all the variables related to the dataset

- `run_analysis.R` - R script to process the data

- `HAR_Tidy_Averages_Dataset.txt` - final tidy dataset with the average values of each variable for each activity and each subject

## Raw Data


- `README.txt`

- `features_info.txt`: Shows information about the variables used on the feature vector.

- `features.txt`: List of all features.

- `activity_labels.txt`: Links the class labels with their activity name.

- `train/X_train.txt`: Training set.

- `train/y_train.txt`: Training labels.

- `test/X_test.txt`: Test set.

- `test/y_test.txt`: Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- `train/subject_train.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- `train/Inertial Signals/total_acc_x_train.txt`: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- `train/Inertial Signals/body_acc_x_train.txt`: The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- `train/Inertial Signals/body_gyro_x_train.txt`: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 
    

## Data Processing

The processing performed on the data is executed by the **`run_analysis.R`** script in this repository, and it can be divided to roughly 6 parts:

**1. Download and unzip the file**

Download the zipfile from the link and subsequently unzipped. 

**2. Load in the targeted datasets **

load all of the relevant data from the folders (observations, subject mapping, and activity mapping), as well as the activity and variable labels

**3. Merge the training and the test sets to create one data set**

Combine different subsetting datasets to create a new dataset called `allData`

**4. Extract only the measurements on the mean and standard deviation for each measurement**

The `grep` function is then used to find the column indices of any variable that contains "mean" or "std" (standard deviation) data. 

**4. Use descriptive activity names to name the activities in the data set**

The existing column names are taken as they are, and the following adjustments are made in order to make the variable names more precise and descriptive:

- "^f" (letter "f" at the beginning) --> "freq" which indicates frequency domain values

- "^t" (letter "t" at the beginning) --> "time" which indicates time domain values
 
- "Acc" --> "Acceleration"

- "-mean()" --> "Mean"

- "-meanFreq()" --> "MeanFrequency"

- "-std()" --> "Std" which means standard deviation

- "Gyro" --> "Gyroscope"

- "Mag" --> "Magnitude"

- "BodyBody" --> "Body"

The adjusted values are then assigned back to the processed data frame as column names.


**5. Creates a tidy data set with the average of each variable for each activity and each subject*

The `aggregate` function is used to summarize the data by taking the mean of the other variables grouped by activity and then id, such that each id will have 6 rows of data averages for each of the 6  correponding activities. With 30 subjects, this ultimately creates a 180 by 81 dataframe.

**6. Output the New Dataset**

The `write.table` function is used to save the resultant 180 by 81 dataframe to a text file titled `HAR_Tidy_Averages_Dataset.txt`.

