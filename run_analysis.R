
#read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

#combine the three files
P_test<-cbind(x_test,y_test,subject_test)

#read train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

#combine the three files
P_train<-cbind(x_train,y_train,subject_train)

#merge test and train
P_data <- rbind(P_test,P_train)

#reading the column names from features.txt
proj_step_2<-read.table("./UCI HAR Dataset/features.txt")
proj_step_2<-rbind(proj_step_2, c("562","Label"), c("563", "subject"))



#convert the data frame to vector and change the column names in X_merged
proj_step_2_v<- proj_step_2[,2]
colnames(P_data) <- proj_step_2_v

#chaning the numeric values in Lable by the actual values
P_data$Label <- as.character(P_data$Label)
P_data$Label[P_data$Label == "1"] <- "WALKING"
P_data$Label[P_data$Label == "2"] <- "WALKING_UPSTAIRS"
P_data$Label[P_data$Label == "3"] <- "WALKING_DOWNSTAIRS"
P_data$Label[P_data$Label == "4"] <- "SITTING"
P_data$Label[P_data$Label == "5"] <- "STANDING"
P_data$Label[P_data$Label == "6"] <- "LAYING"

#Identify columns to be selected from the full data set
toMatch <- c("mean\\(", "std\\(","Label","subject")

#Extracts only the measurements on the mean and standard deviation for each measurement
select_mean_std<-select(P_data, unique(grep(paste(toMatch,collapse="|"),proj_step_2$V2, value=TRUE)))

#Grouping and finding the mean
data_summary <- select_mean_std %>%
        group_by(subject,Label) %>%
        summarise_each(list(mean))

