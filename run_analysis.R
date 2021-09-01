##### This program retrieve the average of mean and standard deviation values of
##### data collected accelerometers from the Samsung Galaxy S smartphone.

library(tidyverse)
library(tibble)
library(dplyr)

### Load and clean activity labels ###
features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactor = FALSE)[2][,1]
features<- features %>% str_remove_all("-") %>% str_remove_all("\\(") %>% str_remove_all("\\)") %>% str_remove_all("\\,")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")[2][,1]


#### Load Train data ####
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactor = FALSE)
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
Y_train<-read.table("UCI HAR Dataset/train/y_train.txt")[,1]
X_train<-tbl_df(X_train)
colnames(X_train)<-features
X_train$subject<-subject_train[,1]
Y_trainnames<-activity_labels[Y_train]
X_train$activity<-Y_trainnames


#### Load Test data ####
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",stringsAsFactor = FALSE)
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
Y_test<-read.table("UCI HAR Dataset/test/y_test.txt")[,1]
X_test<-tbl_df(X_test)
colnames(X_test)<-features
X_test$subject<-subject_test[,1]
Y_testnames<-activity_labels[Y_test]
X_test$activity<-Y_testnames


#### Merge data ####
Merged<-rbind(X_test,X_train)
Merged<-Merged%>%relocate(activity)%>%relocate(subject)


#### Extract only mean and std data #####
Datasnames<-grep("std|mean",features)
Datastdmean<-Merged[Datasnames]

#### Group by activity and subject and get mean ####
Datastdmean$subject<-as.factor(Datastdmean$subject)
Datastdmean$activity<-as.factor(Datastdmean$activity)
Datastdmean<-Datastdmean %>% group_by(activity, subject) 
Summary<-Datastdmean %>% summarise(across(everything(),mean))

#### Write data set ####
write.csv(Summary,"Summary.csv", row.names = FALSE)
