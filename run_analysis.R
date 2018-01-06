if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

# 1. Merges the training and the test sets to create one data set.
# The script :
# * reads data in R and renames y_.. and subject_.. columns to simplify further steps.
# * merges train and test data in two data frames and than combines them in one final data frame "combined_data_set"

X_train_data<-read.table("./UCI HAR DATASET/train/X_train.txt")
y_train_data<-read.table("./UCI HAR DATASET/train/y_train.txt")
names(y_train_data)<-"Activities"
subject_train_data<-read.table("./UCI HAR DATASET/train/subject_train.txt")
names(subject_train_data)<-"Subjects"

combined_train_data<-cbind(subject_train_data, y_train_data, X_train_data)

X_test_data<-read.table("./UCI HAR DATASET/test/X_test.txt")
y_test_data<-read.table("./UCI HAR DATASET/test/y_test.txt")
names(y_test_data)<-"Activities"
subject_test_data<-read.table("./UCI HAR DATASET/test/subject_test.txt")
names(subject_test_data)<-"Subjects"

combined_test_data<-cbind(subject_test_data, y_test_data, X_test_data)

combined_data_set<-rbind(combined_train_data,combined_test_data )

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features<-read.table("./UCI HAR DATASET/features.txt")
clean_features<-features[grep("mean\\(|std", features$V2), ]
combined_data_set<-combined_data_set[c("Subjects", "Activities", paste("V",as.character(clean_features$V1),sep=""))]

# 3. Uses descriptive activity names to name the activities in the data set
activities<-read.table("./UCI HAR DATASET/activity_labels.txt")
combined_data_set$Activities<-mapvalues(combined_data_set$Activities, from=as.vector(activities$V1), to=as.vector(activities$V2))

# 4. Appropriately labels the data set with descriptive variable names
names(combined_data_set)<-mapvalues(names(combined_data_set), from=as.vector(paste("V",as.character(clean_features$V1),sep="")), to=as.vector(clean_features$V2))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data_set<- combined_data_set %>% group_by(.dots=c("Activities", "Subjects"))%>% summarise_at(names(combined_data_set)[3:67], mean, na.rm=FALSE)

#Save data into a file:
write.table(tidy_data_set,"./tidy_data.txt", row.name=FALSE) 
