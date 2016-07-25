# Getting-And-Cleaning-Of-Data
Getting and Cleaning of Data assignments and related files.

This is an assignment for the course project, Getting and Cleaning Data.
This README.md will briefly explain how the R script, run_analysis.R, works.

1. Download and unzip the dataset if it does not already exist in the working directory.

2. Use source("run_analysis.R") command in RStudio. Further explainations are available in the script.

3. There will be 2 output files produced in the current working directory:
   a. merged_data.txt (7.9Mb): It contains a data frame called "Ready_Data" with 10299*68 dimension.
   b. data_with_means.txt (220Kb): It contais a data frame called "Result" with 180*68 dimension.

4. Since we are required to obtain the mean of each variable for each activity and each subject, and there are 
   6 activities in total and 30 subjects in total, we have 180 rows with all the combinations for each of the 66 
   features. Hence, a tidy dataset was created and output as "data_with_means.txt".
