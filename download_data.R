## R script called download_data.R that does the following:

# 0) Download and unzip data.


# Download file

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipedFileName <- "getdata-projectfiles-UCI HAR Dataset.zip"

download.file(URL, destfile = zipedFileName, method="curl")

# unzip file to new folder

unzip(zipedFileName)

