#Getting and cleaning data - august 2014 - run_analsis.R
##Basic principles
My run_analysis script runs in verbose mode, i.e. text is printed in the prompt explaining what's happening (instead of just having to wait it out and hope everything works fine). To allow for easier reading of these lines, after each of them is printed R is instructed to wait for 1 second before continuing execution.

Code segments such as the following can therefore be found in many key points of the script:

```
print("Explanatory text")
Sys.sleep(1)
```

To make the script easie on the computer's memory, my script also runs frequent cleanups of unused data. This is done by using the rm() command once the data has outlived its use.

Moreover, the code is commented for easier interpretation.

These principles can be seen in action at the beginning of the code, when the test files are read and merged:

```
# Import and merge the test data
print("Importing the test data")
Sys.sleep(1)
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/y_test.txt")
testData <- cbind(testSubject, testY, testX)

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(testSubject)
rm(testX)
rm(testY)
```

This segment of code (which is later repeated for the train data) performs the following operations:

1. it notifies the operator that the test data is going to be imported;
2. it reads the subject\_test.txt, the X\_test.txt and the Y\_test.txt files into data frames;
3. it merges these three data frames into one, larger data frame with the cbind() function;
4. it cleans up the temporary data frames used to import the main data.

Since this structure is repeated throughout the script, I will give it for granted in my explanation. I will not therefore repeat for each chunk of code that the data is commented, that a verbose comment is printed on screen and that the unused data is cleaned up.

##How the script works
My run\_analysis.R script performs the operations that follow (commented before the code).

First of all, it imports the test files and merges them into one data frame:
```
# Import and merge the test data
print("Importing the test data")
Sys.sleep(1)
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/y_test.txt")
testData <- cbind(testSubject, testY, testX)

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(testSubject)
rm(testX)
rm(testY)
```

Then, it imports the train files and merges them into one data frame:
```
# Import and merge the train data
print("Importing the train data")
Sys.sleep(1)
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainData <- cbind(trainSubject ,trainY, trainX)

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(trainSubject)
rm(trainX)
rm(trainY)
```

After that, it merges the test and train data frames into the larger UCIHARData data frame:
```
# Merge the whole data
print("Merging the data into one, larger data frame")
Sys.sleep(1)
UCIHARData <- rbind(testData, trainData)

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(testData)
rm(trainData)
```

Then it imports the variable names from the features.txt file, adding the "Subject" and "Activity" labels at the beginning of the labels vector:
```
# Import and prepare the labels
print("Importing and preparing the column names")
Sys.sleep(1)
varLabels <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
varLabels <- rbind(c(" ", "Subject"), c(" ", "Activity"), varLabels)
varLabels <- as.vector(varLabels[,2])
```

It then renames the columns of the UCIHARData data frame:
```
# Set the labels for the data frame
print("renaming the columns")
Sys.sleep(1)
colnames(UCIHARData) <- varLabels
```

Using the grep() function, it finds the indices of the "Subject" and "Activity" columns and of all columns with mean or standard deviation variables:
```
# Extract a list of the labels for mean and standard deviation
print("Indexing the means and standard deviations")
Sys.sleep(1)
stdMeanMeas <- c(varLabels[grep("Subject", varLabels)], varLabels[grep("Activity", varLabels)],varLabels[grep("*std\\(\\)*", varLabels)],varLabels[grep("*mean\\(\\)*", varLabels)])
```

It then subsets the UCIHARData data frame based on those indices, creating the subUCIHAR data frame:
```
# Subset the data frame to extract only the measurements of mean and standard deviation
print("Subsetting the data frame")
Sys.sleep(1)
subUCIHAR <- UCIHARData[,stdMeanMeas]

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(stdMeanMeas)
rm(UCIHARData)
```

It imports the activity labels from the activity\_lables.txt file:
```
# Imports the activity labels
print("Importing the activity labels")
Sys.sleep(1)
actNames <- read.table("./UCI HAR Dataset/activity_labels.txt")
```

Then it cycles through each activity label and renames it in the data frame:
```
# Use descriptive activity names to name the activities in the data set
print("Renaming the activities")
Sys.sleep(1)
for(n in 1:nrow(actNames)) {
  print(as.character(actNames[n,2]))
  Sys.sleep(1)
  subUCIHAR[,"Activity"] <- gsub(actNames[n,1], actNames[n,2], subUCIHAR[,"Activity"])
}
print("All activities renamed")
Sys.sleep(1)

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(actNames)
```
In order to label the data set with descriptive variable names, it performs the following operations:

1. it creates a vector of regular expressions and descriptive elements, aimed at recognising and changing the elements of the untidy variable names;
2. it extracts a vector of variable names to be changed;
3. it cycles through each element in the vector and uses gsub to make the appropriate changes;
4. it applies the new variable names to the data frame.
```
# Appropriately labels the data set with descriptive variable names.
# To automate the process, the descriptive names will follow the order of the elements of
# the original variable names.
print("Creating vector of renamed variable names")
Sys.sleep(1)
originalString <- c("^t", "^f", "-X$", "-Y$", "-Z$", "Jerk", "Mag", "BodyAcc", "GravityAcc", "BodyGyro", "-mean\\(\\)", "-std\\(\\)")
targetString <- c("time -", "frequency -", " X-Axis", " Y-Axis", " Z-Axis", " Jerk Signal -", " Signal Magnitude -", " Body Acceleration -", " Gravity Acceleration -", " Gyroscope -", " Mean Value -", " Standard Deviation -")
variableNames <- cbind(originalString, targetString)
tmpVarLabels <- c(varLabels[grep("*std\\(\\)*", varLabels)],varLabels[grep("*mean\\(\\)*", varLabels)])
for(n in 1:nrow(variableNames)) {
  print(paste(n, "of", nrow(variableNames), sep = " "))
  Sys.sleep(1)
  tmpVarLabels <- gsub(variableNames[n,1], variableNames[n,2], tmpVarLabels)
}
print("Vector created, renaming actual variables")
Sys.sleep(1)
colnames(subUCIHAR) <- c("Subject", "Activity", tmpVarLabels)
print("Variables renamed")
Sys.sleep(1)
```

In the end, to complete the exercise, it performs the following operations:

1. with the aggregate() and factor() functions, it creates a new data frame in which:
  - the subjects and the activities are treated as factors;
  - for each combination of subject and activity, the mean and standard deviations are calculated
  - the data is aggregated based on subject and activity, with one line per combination;
2. the data is saved in a comma-separated txt file (I would have preferred a tab-separated .tsv file, but it isn't supported for the upload by the Coursera platform).
```
# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
print("Creating tidy data set with the averages by subject and activity")
Sys.sleep(1)
meansUCIHAR <- aggregate(subUCIHAR[,-which(names(subUCIHAR) %in% c("Subject","Activity"))], by = list(factor(subUCIHAR$Subject), factor(subUCIHAR$Activity)), FUN = mean)
colnames(meansUCIHAR)[1:2] <- c("Subject", "Activity")
print("Tidy data set created, saving to file")
Sys.sleep(1)
write.table(meansUCIHAR, file = "meansUCIHAR.txt", row.names = FALSE, sep = ",")
print("File saved, goodbye and thanks for your time.")
Sys.sleep(1)
```