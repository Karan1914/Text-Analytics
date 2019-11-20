rm(list=ls()) #remove all the variables from the workspace

#Install Packages
require("tm")||install.packages("tm") #Text Mining
require("stringr")||install.packages("stringr") #string operations
require("wordcloud")||install.packages("wordcloud") #wordcloud graph

#Library
library("tm")
library("stringr")
library("wordcloud")

test=readLines(file.choose()) 
x1=Corpus(VectorSource(test)) #Create the corpus

#Customize Document term Matrix
custom.dtm=function(x1,
                    scheme)  #tf or tfidf
{
  tdm=TermDocumentMatrix(x1,control=list(wordLengths=c(1,Inf)))
  a1=apply(tdm,1,sum)
  a2=((a1>=1))
  tdm.new=tdm[a2,]
  
  #remove blank documents i.e columns with zero sums
  a0=NULL;
  for(i1 in 1:ncol(tdm.new)){if(sum(tdm.new[,i1])==0){a0=c(a0,i1)}}
  length(a0) #no. of empty docs in the corpus
  if(length(a0)>0){tdm.new1=tdm.new[,-a0]}else{tdm.new1=tdm.new};
  dim(tdm.new1) #Reduced tdm
  x2mat=t((tdm.new1))
  return(x2mat)
}

dtm1=custom.dtm(x1,"tf")
freq1=(sort(apply(dtm1,2,sum),decreasing=T))
write.csv(freq1,"F:\\capstone\\Text Analytics\\Output Files\\Tokens.csv")
freq1[1:50]  #View top 50 terms
windows() #new plot window
wordcloud(names(freq1),freq1,scale=c(6,1),1,max.words=50,colors=brewer.pal(8,"Dark2"))
title(sub="Top 50 Term Frquency-Wordcloud")

################# sentiment analysis ################
positive_words=readLines("F:\\capstone\\Text Analytics\\Input Files\\positive_words.txt")

negative_words=readLines("F:\\capstone\\Text Analytics\\Input Files\\negative_words.txt")

######### create positive wordcloud ###############
tdm_temp=t(TermDocumentMatrix(Corpus(VectorSource(test))))
pos.tdm=tdm_temp[,!is.na(match(colnames(tdm_temp),positive_words))]
m=as.matrix(pos.tdm)
v=sort(colSums(m),decreasing=TRUE)
windows()
wordcloud(names(v),v,scale=c(4,0.5),1,colors=brewer.pal(8,"Dark2"))
title(sub="Positive Words-Wordcloud")

######### create negative wordcloud ###############

neg.tdm=tdm_temp[,!is.na(match(colnames(tdm_temp),negative_words))]
m=as.matrix(neg.tdm)
v=sort(colSums(m),decreasing=TRUE)
windows()
wordcloud(names(v),v,scale=c(4,0.5),1,max.words=50,colors=brewer.pal(8,"Dark2"))
title(sub="Negative Words-Wordcloud")

########## Positive words vs. negative words
pcount=NULL
for(i in 1:length(test))
{
  pcount[i]=0
  for(j in 1:length(positive_words))
  {
    pcount[i]=pcount[i]+str_count(test[i],paste("\\b",positive_words[j],"\\b",sep=""))
  }
}

ncount=NULL
for(i in 1:length(test))
{
  ncount[i]=0
  for(j in 1:length(negative_words))
  {
    ncount[i]=ncount[i]+str_count(test[i],paste("\\b",negative_words[j],"\\b",sep=""))
  }
}

doc_id=seq(1:length(test))

windows()
plot(doc_id,ncount,type="l",col="red",xlab="Post",ylab="Word Count")
lines(doc_id,pcount,type="l",col="green")
title(main=paste("Positive words vs Negative Words(Per Post)\n\n Total Posts: ",length(test)))
legend("topright",inset=0.05,c("Positive Words","Negative Words"),fill=c("green","red"),horiz=TRUE)
