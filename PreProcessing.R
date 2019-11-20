rm(list=ls()) #remove all the variables from the workspace

#Install Packages
require("tm")||install.packages("tm") #Text Mining
require("stringr")||install.packages("stringr") #string operations

#Library
library("tm")
library("stringr")

#1. text clean function

text.clean=function(x) #text data
{
  x=gsub("\\<br/>"," ",x)
  x=gsub("\\<br>"," ",x)
  x=tolower(x)
  x=gsub("\\(",' ',x)
  x=gsub("\\)",' ',x)
  x=gsub("\\.",' ',x)
  x=gsub("\\'",' ',x)
  x=gsub("[[:punct:]]"," ",x) #remove punctuation marks
  x=stripWhitespace(x)  #Remove white space
  x=str_trim(x,side=c("both")) #remove leading and trailing white spaces
  return(x)
}

#2. Read text
text=readLines(file.choose()) #Feedback_List

#3. Run text cleaning
 test=text.clean(text)
 
 for(i in 1:length(test))
 {
   if(test[i]=="")
     test[i]=gsub("","document-empty",test[i])
 }
 
 write.csv(test,"F:\\capstone\\Text Analytics\\Output Files\\1. Text_AfterBasicClean.csv")
 
 #4. Remove stopwords
 stopwords=readLines("F:\\capstone\\Text Analytics\\Input Files\\stopwords.txt")
 test=removeWords(test,stopwords) #Remove stopwords created above
 
 test=str_trim(test,side=c("both"))
 
 for(i in 1:length(test))
 {
   if(test[i]=="")
     test[i]=gsub("","document-empty",test[i])
 }
 
 write.csv(test,"F:\\capstone\\Text Analytics\\Output Files\\FinalText.csv")
 