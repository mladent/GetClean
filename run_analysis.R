

## R script called run_analysis.R that does the following:

############################################################################

# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set.
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

############################################################################ 

## 1) Merges the training and the test sets to create one data set.


# Real path: concatenate current position & relative path in 'directory'
directory <- paste( getwd(), "/UCI HAR Dataset/", sep = "" )


# Load single TEST files to appropriate tables
file2proces <- paste( directory, "test/y_test.txt", sep = "" )
Table_y_test <- read.table(file2proces)

file2proces <- paste( directory, "test/X_test.txt", sep = "" )
Table_X_test <- read.table(file2proces)

file2proces <- paste( directory, "test/subject_test.txt", sep = "" )
Table_subject_test <- read.table(file2proces)


# Load single TRAIN files to appropriate tables
file2proces <- paste( directory, "train/y_train.txt", sep = "" )
Table_y_train <- read.table(file2proces)

file2proces <- paste( directory, "train/X_train.txt", sep = "" )
Table_X_train <- read.table(file2proces)

file2proces <- paste( directory, "train/subject_train.txt", sep = "" )
Table_subject_train <- read.table(file2proces)



# Row bind the train and test data
Table_y <- rbind(Table_y_train, Table_y_test)
Table_X <- rbind(Table_X_train, Table_X_test)
Table_subject <- rbind(Table_subject_train, Table_subject_test)

# On this step single tables with X, y and subject data were NOT merged
#  since their manipulation is more simple to explain if kept separate
# Full merge will take place after step 4, before creating the real tidy
#  dataset

############################################################################

## 2) Extracts only the measurements on the mean and standard deviation 
##    for each measurement. 


# Load features Definition file
file2proces <- paste( directory, "features.txt", sep = "" )
Table_features <- read.table(file2proces,stringsAsFactors = FALSE)

# Generate logical table of Features containing mean as "mean("and
#   standard deviation as "std(" 
#   using escape char '\\' for special characters '(' and '-'
Logic_meanstd <- grepl("\\-mean\\(|\\-std\\(",Table_features$V2)

# New table containing only Columns containing mean and
#   standard deviation data 
Table_MeanStd <- Table_X[,Logic_meanstd]

############################################################################

## 3) Uses descriptive activity names to name the activities in the data set.

# Load activity labels:
file2proces <- paste( directory, "activity_labels.txt", sep = "" )
activity_labels <- read.table(file2proces, stringsAsFactors = FALSE)

# # Rename activities in y table by looping through all elements
# #    and replace one by one (e.g. 1 > "WALKING")
# 
# for( n in 1:nrow(activity_labels)) {
#       Table_y[ Table_y==activity_labels$V1[n] ] <- activity_labels$V2[n]
# }

# The execution of this step was postponed after step 5 in order to simplify 
#  the calculation of mean values


############################################################################


## 4) Appropriately labels the data set with descriptive variable names.

colnames(Table_y) <- "Activity"
colnames(Table_subject) <- "Subject"

# Assign features names to Table_X data as presented in file "features.txt"
colnames(Table_X) <- Table_features$V2
# Further modifications to names were excluded on purpose, in order to enable 
#   changes to the source files. By avoiding too specific restrictions depending 
#   on this specific case



# Assign features names to Table containing mean and standard deviation data
#   (only those for which previously defined Logic_meanstd is TRUE!)
colnames(Table_MeanStd) <- Table_features$V2[Logic_meanstd== TRUE]

############################################################################

# At this point all the data was labelled, now we can merge the elements we
#  actually need

# Column binding Subject, Activity and mean + standard dev. data

TidyTable1 <- cbind(Table_subject, Table_y, Table_MeanStd)

############################################################################

## 5) From the data set in step 4, creates a second, independent tidy data set
##    with the average of each variable for each activity and each subject.



# Split the table by 'Subject' and 'Activity'
 
TidyTableSplit <- split(TidyTable1,list(TidyTable1$Subject,TidyTable1$Activity))


# run through the list
for(n in 1:length(TidyTableSplit)){
      
      # calculate mean values for single list elements and for all columns
      if (n == 1){
            TidyTable2 <- sapply(TidyTableSplit[[n]], mean)
      }
      else {      
            TidyTable2 <- rbind( TidyTable2, sapply(TidyTableSplit[[n]], mean) )
            
      }
      
}


# Rename activities in y table by looping through all elements
#    and replace one by one (e.g. 1 > "WALKING")
for( n in 1:nrow(activity_labels)) {
      TidyTable2[,"Activity"][ TidyTable2[,"Activity"]==activity_labels$V1[n] ] <- activity_labels$V2[n]
}
# moved from step 3, making possible to process "sapply(TidyTableSplit[[n]], mean)"
#   on all columns




# Write the output
write.table(TidyTable2, file = "tidySet.txt", row.names = FALSE)

############################################################################


## Read data with 
# read.table("tidySet.txt", header = TRUE)

#  Thank you very much!
