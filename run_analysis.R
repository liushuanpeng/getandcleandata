run_analysis<-function(){
xtest<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
ytest<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")
xtrain<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
ytrain<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")
feature<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")
activityLabels<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")
subjecttrain<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")
subjecttest<-read.table("D:\\getandcleandata\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")
#1:Merges the training and the test sets to create one data set.
	#tidy data of x and y
	x<-rbind(xtest,xtrain)
	y<-rbind(ytest,ytrain)
	fnames<-c("id","feature")
	colnames(feature)<-fnames
	fea<-feature$feature #extract the column name of x and y
	colnames(x)<-fea	   #assignment colname to x
	colnames(y)<-c("activitytype")#assignment colname to y
	#tidy data of subject
	subject<-rbind(subjecttest,subjecttrain)#merge subjecttest and subjecttrain to subject
	colnames(subject)<-c("subject")#change the column name
	numrow <- nrow(y)
	id <- 1:numrow
	y <- cbind(y,id)#add the id column
	subject <- cbind(subject,id)
	x <- cbind(x,id)
	#merge
	mergedata<-merge(subject,y,by="id",all.y=TRUE)
	mergedata<-merge(mergedata,x,by="id",all.y=TRUE)
	#write.table(mergedata,"mergedata.txt",row.names=FALSE)
#2:Extracts only the measurements on the mean and standard deviation for each measurement. 
	j <- 0
	colnam <- names(mergedata)
	extractstd <- NULL
	extractmean <- NULL
	colnamestd <- NULL
	colnamemean <- NULL
	for(n in colnam)
	{	
		j <- j + 1
		logstd <- grepl("std",n)
		logmean <- grepl("mean",n)
		if(logstd == TRUE)
		{
			colnamestd <-c(colnamestd,n)#save the column with std 
			extractstd <- cbind(extractstd,mergedata[,j])#extract the data with std into extractstd
		}
		if(logmean == TRUE)
		{
			colnamemean <- c(colnamemean ,n)
			extractmean <- cbind(extractmean,mergedata[,j])
		}
		colnames(extractstd) <- colnamestd
		colnames(extractmean) <- colnamemean
	}
	#write.table(extractstd,"extractstd.txt",row.names=FALSE)
	#write.table(extractmean,"extractmean.txt",row.names=FALSE)
#3:Uses descriptive activity names to name the activities in the data set
	activity <- c("ida","activityname")
	colnames(activityLabels)<-activity 
	ida<-activityLabels$ida
	acivitytype<-mergedata$activitytype
	#change the num to acivity type in the column of acivitytype
	for(x in ida)
	{
		i<-0
		for(y in acivitytype)
		{
			i <- i + 1
			if(x == y)
			{
				if(x == 1)
				{
				  acivitytype[i] <- "WALKING"
				}
				if(x == 2)
				{
				  acivitytype[i] <- "WALKING_UPSTAIRS"
				}
				if(x == 3)
				{
				  acivitytype[i] <- "WALKING_DOWNSTAIRS"
				}
				if(x == 4)
				{
				  acivitytype[i] <- "SITTING"
				}
				if(x == 5)
				{
				  acivitytype[i] <- "STANDING"
				}
				if(x == 6)
				{
				  acivitytype[i] <- "LAYING"
				}
				 
			}
		}
	}
	mergedata$activitytype <- acivitytype
	#write.table(mergedata,"mergedata4.txt",row.names=FALSE)
#4:Appropriately labels the data set with descriptive variable names.
	#I think the default variable name is perfectful
#5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	extractstd <- cbind(extractstd,mergedata[,1:3])
	extractmean <- cbind(extractmean,mergedata[,1:3])

	sub <- extractstd$subject	
	sub <- unique(sub)
	activity <- extractstd$activitytype
	activity <- unique(activity)

	#extract the average include std 

	everyPA <- NULL
	actper <- NULL
	actperstd <- NULL
	
	for(p in sub)
	{
		for(a in activity)
		{
			p<-as.character(p)
			actperx <- paste(a,p, sep="")
			actper <- c(actper,actperx)
			everyPA <- extractstd[which(extractstd$subject == p & extractstd$activitytype == a),]
			nc <- ncol(everyPA)
			
			nc<-nc-3
			e<-everyPA[,1:nc]
			em<-apply(e[,1:nc],2,mean)
			person <- c(person,p)
			activitytype <- c(activitytype ,a)
			actperstd <- rbind(actperstd ,em)
		}
	}
	
	rownames(actperstd) <- actper
	
	#extract the average include mean 
	everyPB <- NULL
	actperA <- NULL
	actpermean <- NULL
	activitytype <- NULL
	person <- NULL
	for(p in sub)
	{
		for(a in activity)
		{
			p<-as.character(p)
			actperx <- paste(a,p, sep="")
			actperA <- c(actperA,actperx)
			everyPB <- extractmean[which(extractmean$subject == p & extractmean$activitytype == a),]
			nc <- ncol(everyPB)
		
			nc<-nc-3
			e<-everyPB[,1:nc]
			em<-apply(e[,1:nc],2,mean)
			person <- c(person,p)
			activitytype <- c(activitytype ,a)
			actpermean <- rbind(actpermean ,em)
		}
	}
	
	rownames(actpermean) <- actperA
	
	total<-cbind(actpermean,actperstd)
	total <- cbind(total ,activitytype)
	total <- cbind(total ,person)
	View(total)
	write.table(total,"result.txt",row.names=FALSE)











}
