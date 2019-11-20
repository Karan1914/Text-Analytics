# Text-Analytics
# Sentiment Analysis
## Analysing Text to predict polarity by performing sentiment analysis




## Steps for text analytics: 

### Steps to follow:

## (I) Requirements
1. Save the attached three files in a folder where you will save all input files:
- positive_words.txt: list of positive words
- negative_words.txt: list of negative words
- stopwords.txt:  list of words of no significance like AND, OR, WE, HIS, HER etc., which will be removed from the input data.

You can add words in any of them if required.

In your input file, make some changes in the word list, 
ex. Convert "promoters sold" to "promoterssold" so that the newly formed word can be targeted as positive or negative. Also update the dictionaries accordingly.

## (II) Preprocessing.R

1. Copy the content from your source (excel, csv, etc. ) to a text file (say feedback.txt) 
2. Open the script Preprocessing.R and change the paths according to your system. 
("Read" paths for input and "writecsv" paths for output) 
3. Run the script. It will ask for input. Chose feedback.txt
4. Also pass the stopwords file as input in the next step.
5.The script will give 2 files as output. 
"Final_text.csv" will be given as output and will be used in other scripts. 
6.Copy the content from final_text.csv to a text file (say final_text.txt) 

## (III) Tokenization.R
1. Open the script tokenziation.R and change paths acc to your system.
2. For positive and negative words, update the path where both the dictionaries Are kept.
2. Run the script. it will ask for input. Provide final_text.txt
3. It will give you top 50-word cloud, positive and negative word cloud.
4.It will also give you a file tokens.csv where you have all the tokens fetched from your input. You can analyze and add them accordingly in positive or negative dictionaries.

## (IV) Score_polarity.R
1. Open the script and update the input/output paths.
2. Run the script. It will ask for input. pass the final_text.txt
3. The script will give you bar charts and pie charts for polarity.

Text analyzing and calculating polarity -positive, negative or neutral. Also, in one graph the extent of polarity is displayed (how much negative or how much positive). Also, most used negative and positive words are displayed.


