rm(list=ls()) #remove all the variables from the workspace

#Install Packages
require("tm")||install.packages("tm") #Text Mining
require("stringr")||install.packages("stringr") #string operations
require("wordcloud")||install.packages("wordcloud") #wordcloud graph
require("plyr")||install.packages("plyr")
require("ROAuth")||install.packages("ROAuth")

library(plyr)
library(ROAuth)
library(stringr)
library(ggplot2)
library(wordcloud)

if(FALSE)
{
  #score=number of positive-number of negative
}
setwd("F:\\capstone\\Text Analytics\\Input Files")
text=readLines(file.choose())

posText<-read.delim("positive_words.txt",header=FALSE,stringsAsFactors=FALSE)
posText<-posText$V1
posText<-unlist(lapply(posText,function(x){str_split(x,"\n")}))
posText

negText<-read.delim("negative_words.txt",header=FALSE,stringsAsFactors=FALSE)
negText<-negText$V1
negText<-unlist(lapply(negText,function(x){str_split(x,"\n")}))

pos.words=c(posText)
neg.words=c(negText)


score.sentiment=function(sentences,pos.words,neg.words,.progress='none')
{
  scores=laply(sentences,
  function(sentence,pos.words,neg.words)
  {
    #create missing value
    tryTolower=function(x)
    {
      y=NA
      # trycatch error
      try_error=tryCatch(tolower(x),error=function(e) e)
      #if not an error
      if(!inherits(try_error,"error"))
        y=tolower(x)
      return(y)
    }
    
    #use tryLower with sapply
    sentence=sapply(sentence,tryTolower)
    word.list=str_split(sentence,"\\s+")
    words=unlist(word.list)
    
    #compare words to the dictionaries of positive & negative term
    pos.matches=match(words,pos.words)
    neg.matches=match(words,neg.words)
    
    #get the position of matched term or NA
    pos.matches=!is.na(pos.matches)
    neg.matches=!is.na(neg.matches)
    
    #final score
    score=sum(pos.matches)-sum(neg.matches)
    
    #handle more nagetive cases
    if(score==0 && sum(neg.matches)>0)
      score=-1
    
    return(score)
  },pos.words,neg.words,.progress=.progress)
  
  #data frame with scores for each sentence
  scores.df=data.frame(text=sentences,score=scores)
  return(scores.df)
}

scores=score.sentiment(text,pos.words,neg.words,.progress='text')
if(FALSE)
{
scores$positive<-as.numeric(scores$score>0)
scores$negative<-as.numeric(scores$score<0)
scores$neutral<-as.numeric(scores$score==0)

df=ddply(scores,NULL,summarise,
         pos_count=sum(positive),
         neg_count=sum(negative),
         neu_count=sum(neutral))
}
#add column polarity based on score value

scores$polarity<-ifelse(scores$score>0,"Positive",ifelse(scores$score<0,"Negative",ifelse(scores$score==0,"Neutral",0)))
print(scores)

write.csv(scores,"F:\\capstone\\Text Analytics\\Output Files\\Score_Polarity.csv")

#compute sumary
df=ddply(scores,NULL,summarise,
         pos_count=sum(polarity=="Positive"),
         neg_count=sum(polarity=="Negative"),
         neu_count=sum(polarity=="Neutral"))


df$total_count=df$pos_count+df$neg_count+df$neu_count

df$pos_prcnt_score=round(100*df$pos_count/df$total_count)
df$neg_prcnt_score=round(100*df$neg_count/df$total_count)
df$neu_prcnt_score=round(100*df$neu_count/df$total_count)
print(df)

#plot polarity in bar graph
Categories<-c("Negative","Neutral","Positive")
Frequency<-c(df$neg_count,df$neu_count,df$pos_count)
Colors<-c("#F8766D","#619CFF","mediumseagreen")

total_count<-format(df$total_count,big.mark=",",scientific=FALSE,trim=TRUE)
title<-paste("Overall polarity\n\nTotal Posts : ",total_count)

data<-data.frame(Categories,Frequency)

windows()
p<-ggplot(data=data,aes(x=Categories,y=Frequency))+
  geom_bar(stat="identity",fill=Colors,width=0.7)+
  ggtitle(title)+
  xlab("Polarity Categories")+
  ylab("Frequency")+
  theme(plot.title=element_text(size=rel(1.0),hjust=0.5,face="bold"),
        text=element_text(color="grey20",size=14))+ #size of axis labels
  geom_text(aes(label=Frequency),vjust=-0.5,size=3.5)+ #bar labels
  scale_color_manual(values=Colors) #outline
p


if(FALSE)
{
  qplot(factor(scores$polarity),
        data=scores,
        geom="bar",
        fill=factor(polarity))+
    xlab("Polarity Categories")+
    ylab("Frequency")+
    ggtitle("Sentiments(classification by polarity)")+
    scale_fill_manual("",#legend title
                      labels=c(paste("Negative Posts=",df$neg_count),
                               paste("Neutral Posts=",df$neu_count),
                               paste("Positive Posts=",df$pos_count)),
                      values=c("#F8766D","#619CFF","#00BA38"))
}

#plot scores in bar graph
if(FALSE)
{
  gg_color_hue<-function(n)
  {
    hues=seq(15,375,length=n+1)
    hcl(h=hues,l=65,c=100)[1:n]
  }
}

 
title<-paste("Polarity Distribution\n\nTotal Posts: ",total_count)


rm(data_scores)
data_scores<-count(factor(scores$score))
colors_arr="grey"
for(i in 1:nrow(data_scores))
{
  value=as.character(data_scores[i,1])
  colors_arr[i]<-ifelse(value>0,"mediumseagreen",ifelse(value<0,"#F8766D","#619CFF"))
  
}
print(colors_arr)

data_scores<-cbind(data_scores,colors_arr)
colors_factor_level=factor(data_scores$colors_arr,levels=c("#F8766D","#619CFF","mediumseagreen"))
legend_labels<-c(paste("Negative Posts=",df$neg_count," "),
                 paste("neutral Posts=",df$neu_count," "),
                 paste("Positive Posts=",df$pos_count))
legend_colors<-c("#F8766D","#619CFF","mediumseagreen")

windows()
p<-ggplot(data=data_scores,aes(x=x,y=freq,fill=colors_factor_level))+
  geom_bar(stat="identity",width=0.7)+
  ggtitle(title)+
  xlab("Sentiment Score")+ylab("Frequency")+
  theme(plot.title=element_text(size=rel(1.0),hjust=0.5,face="bold"),
        text=element_text(color="grey20",size=14))+
        geom_text(aes(label=freq),vjust=0.5,size=3.5)+
          scale_fill_manual(name="",values=legend_colors,labels=legend_labels)+
          theme(legend.position="top")
        p

        
        if(FALSE)
        {
          windows()
          qplot(factor(score),
                data=scores,
                geom="bar",
                fill=factor(score))+
            scale_fill_discrete("Score")+
            xlab("Sentiment Score")+
            ylab("Frequency")+
            ggtitle("Sentiment(classification by scores)")
        }
        
        #pie chart for positive,negative,neutral
        windows()
        attach(df)
        x=c(df$neg_prcnt_score,df$neu_prcnt_score,df$pos_prcnt_score)
        
        lbls=c("Negative","Neutral","Positive")
        lbls<-paste(lbls,x,sep=" ")
        lbls<-paste(lbls,"%",sep=" ")
        pie(x,labels=lbls,col=c("#F8766D","#619CFF","#00BA38"),main="Polarity Distribution")
       