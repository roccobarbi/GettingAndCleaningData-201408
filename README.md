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

```
```
4. it imports the variable names from the features.txt file;

```
```
5. it adds the "Subject" and "Activity" labels at the beginning of the labels vector;

```
```
6. it renames the columns of the UCIHARData data frame;

```
```
7. it extracts with the grep() function the indices of the "Subject" and "Activity" columns and of all columns with mean or standard deviation variables;
8. it subsets the UCIHARData data frame based on those indices, creating the subUCIHAR data frame;
9. it imports the activity labels from the activity\_lables.txt file;
10. it cycles through each activity label