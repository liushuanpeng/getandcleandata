run code instruction:
	
	the data set input path : ("D:\getandcleandata\getdata-projectfiles-UCI HAR Dataset\UCI HAR Dataset")
	
	the run_analysis.R in the path : ("D:\getandcleandata")

	in the code: merge the data set : x_train.txt, x_test.txt, y_train, y_test.txt, subject_train.txt, subject_test.txt
					  activity_labels.txt, features.txt.then extract the column which include "std" and 						  "mean",then change the data which is 1--6 to corresponding value,for example : 2 					  corresponding "STANDING";9 corresponding "WALKING",then compute value in the step5.

step one: Merges the training and the test sets to create one data set.
	use rbind to merge xtest and xtrain to x,use rbind to merge ytest and ytrain to y,then extract the column from 			feature,assignment the column to x and y，then use rbind to merge subjecttest and subjecttrain to subject£，then add the 	"id" column tox,y and subject,finally,merge them to the result data.

step two: Extracts only the measurements on the mean and standard deviation for each measurement.
 	  we find the data that include the "std" and "mean",extract them, include the "std" save in extractstd , include the 		  "mean" save in the variable extractmean.

step three: Uses descriptive activity names to name the activities in the data set
	    we use two for loop to find the activity number corresponding the activity name ,then let it change to the name.  

step four: Appropriately labels the data set with descriptive variable names.

	   I think the default variable name is perfectful,so I do not change it.

step five:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each        	  activity and each subject.
	  we use two for loop to find that each one corresponds to each activity,then compute the mean of them,then extract 		  the mean value to the variable	of actpermean.
