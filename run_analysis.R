library('reshape2')
## Download and unzipping the dataset
if(!file.exists("./data")) {dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./Dataset.zip")
unzip(zipfile = "./Dataset.zip")

## Step 1: Merging Training and Test sets to create one dataset
## Firstly, load the datasets
Train_Data <- read.table("./UCI HAR Dataset/train/X_train.txt")
dim(Train_Data)
head(Train_Data)

Train_Label <- read.table("./UCI HAR Dataset/train/y_train.txt")
table(Train_Label)

Train_Subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Test_Data <- read.table("./UCI HAR Dataset/test/X_test.txt")
dim(Test_Data)

Test_Label <- read.table("./UCI HAR Dataset/test/y_test.txt")
table(Test_Label)

Test_Subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Merge the loaded datasets into one
MergeData <- rbind(Train_Data, Test_Data)
MergeLabel <- rbind(Train_Label, Test_Label)
MergeSubject <- rbind(Train_Subject, Test_Subject)
dim(MergeData)
dim(MergeLabel)
dim(MergeSubject)

## Step 2: Extracting only the measurements on the mean and standard deviation for each measurement
## Load features.txt
Features <- read.table("./UCI HAR Dataset/features.txt")
dim(Features)

Features_MeanStdInd <- grep("mean\\(\\)|std\\(\\)", Features[,2])
length(Features_MeanStdInd)

MergeData <- MergeData[, Features_MeanStdInd]
dim(MergeData)

## Removing '()'
names(MergeData) <- gsub("\\(\\)", "", Features[Features_MeanStdInd, 2])

## Removing '-'
names(MergeData) <- gsub("-", "", names(MergeData))

## Making the words readable
names(MergeData) <- gsub("mean", "Mean", names(MergeData))
names(MergeData) <- gsub("std", "Std", names(MergeData))

## Step 3: Uses descriptive activity names to name the activities in the data set
## Load activity.txt 
Activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Remove '_' and convert all characters to lowercase
Activity[, 2] <- tolower(gsub("_", "", Activity[, 2]))

## Convert the first letter of the second word to uppercase
substr(Activity[2, 2], 8, 8) <- toupper(substr(Activity[2, 2], 8, 8))
substr(Activity[3, 2], 8, 8) <- toupper(substr(Activity[3, 2], 8, 8))

## Merge Activity data into MergeLabel and rename the column header to "Activity"
ActivityLabel <- Activity[MergeLabel[, 1], 2]
MergeLabel[, 1] <- ActivityLabel
names(MergeLabel) <- "Activity"

## Step 4: Appropriately labels the data set with descriptive variable names
## Rename the column to "Subject"
names(MergeSubject) <- "Subject"

## Merge all 3 datasets into one complete dataset
Ready_Data <- cbind(MergeSubject, MergeLabel, MergeData) 
dim(Ready_Data)

## Create the completed dataset in a txt file
write.table(Ready_Data, "merged_data.txt")

## Step 5: From the data set in step 4, creates a second, independent tidy data set with the
##         average of each variable for each activity and each subject
## Caculate the number of rows needed to create a matrix
SubjectLength <- length(table(MergeSubject))
ActivityLength <- dim(Activity)[1]

## Calculate the number of columns needed to create a matrix
ColumnLength <- dim(Ready_Data)[2]

## Create the matrix
Result <- matrix(NA, nrow = SubjectLength*ActivityLength, ncol = ColumnLength)

## Check whether it is a data frame or coerce it if possible
Result <- as.data.frame(Result)

## Transfer the column names in Ready_Data to Result
colnames(Result) <- colnames(Ready_Data)

##  Calculate the average of each variable for each activity and each subject
row <- 1
for(i in 1:SubjectLength)
{
  for(j in 1: ActivityLength)
  {
    Result[row, 1] <- sort(unique(MergeSubject)[, 1]) [i]
    Result[row, 2] <- Activity[j, 2]
    Bool1 <- i == Ready_Data$Subject
    Bool2 <- Activity[j, 2] == Ready_Data$Activity
    Result[row, 3:ColumnLength] <- colMeans(Ready_Data[Bool1&Bool2, 3:ColumnLength])
    row <- row + 1
  }
}

## Display dataset
head(Result)

## Create a txt file of Result dataset with appropriate names
write.table(Result, "data_with_means.txt", row.names = FALSE)