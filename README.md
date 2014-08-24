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

##How the script works