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

# Merge the whole data
print("Merging the data into one, larger data frame")
Sys.sleep(1)
UCIHARData <- rbind(testData, trainData)

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(testData)
rm(trainData)

# Import and prepare the labels
print("Importing and preparing the column names")
Sys.sleep(1)
actLabels <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
actLabels <- rbind(c(" ", "Subject"), c(" ", "Activity"), actLabels)
actLabels <- as.vector(actLabels[,2])

# Set the labels for the data frame
print("renaming the columns")
Sys.sleep(1)
colnames(UCIHARData) <- actLabels

# Extract a list of the labels for mean and standard deviation
print("Indexing the means and standard deviations")
Sys.sleep(1)
stdMeanMeas <- c(actLabels[grep("Subject", actLabels)], actLabels[grep("Activity", actLabels)],actLabels[grep("*std\\(\\)*", actLabels)],actLabels[grep("*mean\\(\\)*", actLabels)])

# Subset the data frame to extract only the measurements of mean and standard deviation
print("Subsetting the data frame")
Sys.sleep(1)
subUCIHAR <- UCIHARData[,stdMeanMeas]

# Cleanup of temporary data
# This should reduce the total amount of memory needed to run this script
rm(stdMeanMeas)
rm(UCIHARData)

# Imports the activity labels
print("Importing the activity labels")
Sys.sleep(1)
actNames <- read.table("./UCI HAR Dataset/activity_labels.txt")

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

# Appropriately labels the data set with descriptive variable names.
# To automate the process, the descriptive names will follow the order of the elements of
# the original variable names.
print("Creating vector of renamed variable names")
Sys.sleep(1)
originalString <- c("^t", "^f", "-X$", "-Y$", "-Z$", "Jerk", "Mag", "BodyAcc", "GravityAcc", "BodyGyro", "-mean\\(\\)", "-std\\(\\)")
targetString <- c("time -", "frequency -", " X-Axis", " Y-Axis", " Z-Axis", " Jerk Signal -", " Signal Magnitude -", " Body Acceleration -", " Gravity Acceleration -", " Gyroscope -", " Mean Value -", " Standard Deviation -")
variableNames <- cbind(originalString, targetString)
tmpActLables <- c(actLabels[grep("*std\\(\\)*", actLabels)],actLabels[grep("*mean\\(\\)*", actLabels)])
for(n in 1:nrow(variableNames)) {
  print(paste(n, "of", nrow(variableNames), sep = " "))
  Sys.sleep(1)
  tmpActLables <- gsub(variableNames[n,1], variableNames[n,2], tmpActLables)
}
print("Vector created, renaming actual variables")
Sys.sleep(1)
colnames(subUCIHAR) <- c("Subject", "Activity", tmpActLables)
print("Variables renamed")
Sys.sleep(1)

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