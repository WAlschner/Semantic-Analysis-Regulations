#################################################
### Semantic Analysis of Canadian Regulations ###
#################################################

### Version: 5 October 2018

### This code investigates the text of federal Canadian regulations based on 4 aspects:
### 1. Prescriptivity: How binding are regulations?
### 2. Flexibility: How responsive are regulations to changing circumstances?
### 3. Complexity: How easily understandable are regulations?
### 4. Age: What is the average age of regulations and are they "outdated"?

### This code is distributed for free use under the MIT License.
### Created by Peter C. Zachar, Marco Pontello and Wolfgang Alschner

### ==========
### Set Up Working Environment
###

### Working Directory should be set, depending on user.
## E.g. setwd("C:/MyWorkingDirectory/Regulations)


### ==========
### Load and Preprocess Canadian Regulation Data
###

## Load the regulations_data dataset into Rstudio.
regulations_data <- readRDS("regulations_data_Oct2018.rds")

## Eliminate all regulations that have been repealed.
regulations_data <- regulations_data[!(regulations_data$repealed=="yes"), ]

## Add leading zero to single-digit months.
regulations_data$LastAmendedDate <- gsub("(?<=-)(\\d)(?=-)", "0\\1", regulations_data$LastAmendedDate, perl = TRUE)

## Add leading zero to single-digit days.
regulations_data$LastAmendedDate <- gsub("(?<=-\\d{2}-)(\\d)(?!\\d)", "0\\1", regulations_data$LastAmendedDate, perl = TRUE)

## Convert regulation texts to lowercase to facilitate matching.
regulations_data$full_text <- tolower(regulations_data$full_text)

## Convert regulation word count to numbers.
regulations_data$wordcount <- as.numeric(as.vector.factor(regulations_data$wordcount))

## OPTIONAL: Eliminate all regulations that contain less than 100 words.
## Please uncomment to apply: 
regulations_data <- regulations_data[!(regulations_data$wordcount < 100), ]

###
### Load libraries used in this analysis.
###
### If you do not already have these libraries installed, you will need to do so (e.g. install.packages("anytime")) before continuing.
###

library(anytime)
library(stringr)


### ==========
### 1. Prescriptivity ###
###
### NOTES ON METHOD:
### The following code will count the occurences of words of interest within a regulation, and use them to:
### 1) Generate indices for prescriptions and permissions; and
### 2) Calculate a Prescriptivity Score
### for each regulation.

###
### Count words associated with prescriptions and permissions.
###

### Count prescriptions per regulation.
## Read prescription words from csv file.
## Note: User may need to modify the directory to reflect the location of their word list CSV file.
wordlist_prescriptions <- read.csv("Wordlists/prescriptions.csv", stringsAsFactors = FALSE)

## Create object in which to store mapping results for prescriptions.
word_mapping_prescriptions <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1]))) 

## Word mapping: Check whether words in the prescriptions wordlist are in a regulation's text.
for (word_element in wordlist_prescriptions$words) {
  word_element <- tolower(word_element)
  print (word_element)
  word_mapped <- as.data.frame(str_count(regulations_data$full_text, word_element))
  word_mapping_prescriptions <- cbind(word_mapping_prescriptions, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_prescriptions) <- wordlist_prescriptions$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_prescriptions) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_prescriptions, file="regulations_data_word_mapping_prescriptions.csv")

### Count permissions per regulation.
## Read permissive words from csv file.
## Note: User may need to modify the directory to reflect the location of their word list CSV file.
wordlist_permissions <- read.csv("Wordlists/permissions.csv", stringsAsFactors = FALSE)

## Create object in which to store mapping results for permissions.
word_mapping_permissions <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1]))) 

## Word mapping: Check whether words in the permissions wordlist are in a regulation's text.
for (word_element in wordlist_permissions$words) {
  word_element <- tolower(word_element)
  print (word_element)
  word_mapped <- as.data.frame(str_count(regulations_data$full_text, word_element))
  word_mapping_permissions <- cbind(word_mapping_permissions, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_permissions) <- wordlist_permissions$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_permissions) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_permissions, file="regulations_data_word_mapping_permissions.csv")

###
### Sum counted words of interest by type, per regulation.
###
regulations_data$PRESCRIPTIVITY_prescriptions_RawCount <- rowSums(word_mapping_prescriptions)
regulations_data$PRESCRIPTIVITY_permissions_RawCount <- rowSums(word_mapping_permissions)

###
### Normalize word counts per regulation.
###

## Normalize counts of words of interest per regulation, per 100 words.
regulations_data$PRESCRIPTIVITY_prescriptions_Index <- regulations_data$PRESCRIPTIVITY_prescriptions_RawCount/(regulations_data$wordcount/100)
regulations_data$PRESCRIPTIVITY_permissions_Index <- regulations_data$PRESCRIPTIVITY_permissions_RawCount/(regulations_data$wordcount/100)

###
### Calculate Overall Prescriptivity Score
###
### NOTES ON METHOD:
### The Prescriptivity Score is generated by dividing the prescriptions index by the permissions index.
### This reflects the role of permissions in a regulation in mitigating the effects of prescriptions.
### To avoid divisions by or of zero where no permissive or prescriptive words exist, we add +1 to the raw scores and +2 to wordcount to compensate.
###

regulations_data$PRESCRIPTIVITY_Index <- ((regulations_data$PRESCRIPTIVITY_prescriptions_RawCount+1)/((regulations_data$wordcount+2)/100)) / ((regulations_data$PRESCRIPTIVITY_permissions_RawCount+1)/((regulations_data$wordcount+2)/100))



### ==========
### 2. Flexibility ###
###
### NOTES ON METHOD:
### This analysis is a flexibility analysis using wordlists. 
### The wordlists contain words that have been proven to relate to two dimensions of flexibility:
### 1) Exceptions (flexibility for regulatee)
### 2) Discrections (flexibility for regulator)

###
### Count words associated with exceptions and discretions.
###


### Count exceptions per regulation.
## Read exception words from csv file.
## Note: User may need to modify the directory to reflect the location of their word list CSV file.
wordlist_exceptions <- read.csv("Wordlists/exceptions.csv", stringsAsFactors = FALSE)

## Create object in which to store mapping results for exceptions.
word_mapping_exceptions <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1]))) 

## Word mapping: Check whether words in the exceptions wordlist are in a regulation's text.
for (word_element in wordlist_exceptions$words) {
  word_element <- tolower(word_element)
  print (word_element)
  word_mapped <- as.data.frame(str_count(regulations_data$full_text, word_element))
  word_mapping_exceptions <- cbind(word_mapping_exceptions, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_exceptions) <- wordlist_exceptions$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_exceptions) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_exceptions, file="regulations_data_word_mapping_exceptions.csv")

### Count discretions per regulation.
## Read discretion words from csv file.
## Note: User may need to modify the directory to reflect the location of their word list CSV file.
wordlist_discretions <- read.csv("Wordlists/discretions.csv", stringsAsFactors = FALSE)

## Create object in which to store mapping results for exceptions.
word_mapping_discretions <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1]))) 

## Word mapping: Check whether words in the exceptions wordlist are in a regulation's text.
for (word_element in wordlist_discretions$words) {
  word_element <- tolower(word_element)
  print (word_element)
  word_mapped <- as.data.frame(str_count(regulations_data$full_text, word_element))
  word_mapping_discretions <- cbind(word_mapping_discretions, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_discretions) <- wordlist_discretions$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_discretions) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_discretions, file="regulations_data_word_mapping_discretions.csv")

###
### Sum counted words of interest by type, per regulation.
###
regulations_data$FLEXIBILITY_exceptions_RawCount <- rowSums(word_mapping_exceptions)
regulations_data$FLEXIBILITY_discretions_RawCount <- rowSums(word_mapping_discretions)


###
### Normalize word counts per regulation.
###

## Normalize counts of words of interest per regulation, per 100 words.
regulations_data$FLEXIBILITY_exceptions_Index <- regulations_data$FLEXIBILITY_exceptions_RawCount/(regulations_data$wordcount/100)
regulations_data$FLEXIBILITY_discretions_Index <- regulations_data$FLEXIBILITY_discretions_RawCount/(regulations_data$wordcount/100)



### ==========
### 3. Complexity: Wordlists Analysis #####
###
### NOTES ON METHOD:
### This analysis is a complexity analysis using wordlists. 
### The wordlists contain words that have been proven to relate to complexity.
###
### This analysis is in 2 parts:
### 1) Legal Jargon
### 2) Cross-referencing
### It is important to keep each section separate from each other, because object names are repeated.
### I.e. Do not run the entire sheet of code at once.

###
### 1) Complexity: Legal Jargon Analysis ####
###

## Read Legal Jargon words from CSV file.
## Note: User may need to modify the directory to reflect the location of their wordlist CSV file.
wordlist_legal_jargon <- read.csv("Wordlists/words_legal_jargon.csv", stringsAsFactors =FALSE)

## Create object in which to store mapping results for Legal Jargon.
word_mapping_legal_jargon <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1]))) 

## Word mapping: Check whether words in Legal Jargon wordlist are in a regulation's text.
for (word_element in wordlist_legal_jargon$words) {
  word_element <- tolower(word_element)
  print(word_element)
  word_mapped  <- as.data.frame(str_count(regulations_data$full_text, word_element))  
  word_mapping_legal_jargon <- cbind(word_mapping_legal_jargon, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_legal_jargon) <- wordlist_legal_jargon$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_legal_jargon) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_legal_jargon, file="regulations_data_word_mapping_legal_jargon.csv")

## Sum counted Legal Jargon words, per regulation.
regulations_data$COMPLEXITY_legal_jargon_RawCount <- rowSums(word_mapping_legal_jargon)


###
### Normalize Legal Jargon word count per regulation.
###

### Normalize word_mapping_legal_jargon_count per regulation, per 100 words
regulations_data$COMPLEXITY_legal_jargon_Index <- regulations_data$COMPLEXITY_legal_jargon_RawCount/(regulations_data$wordcount/100)


####
#### 2) Complexity: Cross-referencing ####
####

## Read Legal Jargon words from CSV file.
## Note: User may need to modify the directory to reflect the location of their wordlist CSV file.
wordlist_cross_referencing <- read.csv("Wordlists/words_cross_referencing.csv", stringsAsFactors =FALSE)

## Create object in which to store mapping results for Cross-Referencing.
word_mapping_cross_referencing <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1]))) 

## Word mapping: Check whether words in Legal Jargon wordlist are in a regulation's text.
for (word_element in wordlist_cross_referencing$words) {
  word_element <- tolower(word_element)
  print(word_element)
  word_mapped  <- as.data.frame(str_count(regulations_data$full_text, word_element))  
  word_mapping_cross_referencing <- cbind(word_mapping_cross_referencing, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_cross_referencing) <- wordlist_cross_referencing$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_cross_referencing) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_cross_referencing, file="regulations_data_word_mapping_cross_referencing.csv")


## Sum counted Cross-Referencing words, per regulation.
regulations_data$COMPLEXITY_cross_referencing_RawCount <- rowSums(word_mapping_cross_referencing)


###
### Normalize Cross-Referencing word count per regulation.
###

## Normalize Cross-Referencing per regulation, per 100 words
regulations_data$COMPLEXITY_cross_referencing_Index <- regulations_data$COMPLEXITY_cross_referencing_RawCount/(regulations_data$wordcount/100)


### ==========
### Basic Age Calculation
###
### NOTES ON METHOD:
### The following code will calculate the numbers of days between today's date and the regulation's last amended date
###


###
### The date in the last_amended column is formatted in an unusual way. 
### We will use use the "anytime" package to convert it to the date class.
###

## Use the "anydate" function from the anytime package to convert the last_amended column data into the date class.
regulations_data$LastAmendedDate <- anydate(regulations_data$LastAmendedDate)

## Assign today's date to the object "Today".
## Note: Adjust according to the date from which you are interested in calculating.
Today <- anydate("2018-10-05")

## Create a new column that subtracts the last_amended date from Today's date.
regulations_data$AGE_DaysLastModified <- Today - regulations_data$LastAmendedDate


### ==========
### Age based on Outdated Words
###
### NOTES ON METHOD:
### This provides a count of words that are considered outdated (e.g. fax, pencil), which gives insight into a regulation's age.
###

## Read outdated words from CSV file.
## Note: User may need to modify the directory to reflect the location of their wordlist CSV file.
wordlist_outdated_words <- read.csv("Wordlists/outdated_words.csv", stringsAsFactors =FALSE)

## Create object in which to store mapping results for outdated words.
word_mapping_outdated_words <- data.frame(matrix(ncol = 0, nrow = length(regulations_data[,1])))

## Word mapping: Check whether words in outdated wordlist are in a regulation's text.
for (word_element in wordlist_outdated_words$words) {
  word_element <- tolower(word_element)
  print (word_element)
  word_mapped  <- as.data.frame(str_count(regulations_data$full_text, word_element))  
  word_mapping_outdated_words <- cbind(word_mapping_outdated_words, word_mapped)
}

## Rename the columns to correspond with the words counted.
colnames(word_mapping_outdated_words) <- wordlist_outdated_words$words

## Rename the rows to correspond with the regulations identifier.
rownames(word_mapping_outdated_words) <- regulations_data$reg_id

## Save the resulting data as a CSV file. 
## Please uncomment to create file: 
# write.csv(word_mapping_outdated_words, file="regulations_data_word_mapping_outdated_words.csv")


## Sum counted outdated words, per regulation.
regulations_data$AGE_outdated_words_RawCounts <- rowSums(word_mapping_outdated_words)


###
### Normalize outdated word count per regulation.
###

## Normalize word_mapping_cross_referencing_count per regulation, per 100 words
regulations_data$AGE_outdated_words_Index <- regulations_data$AGE_outdated_words_RawCounts/(regulations_data$wordcount/100)


### ==========
### Output of Analyses as Meta Data File

## Remove full texts from regulation data for ease of handling of CSV.
regulations_data_analysis <- regulations_data[,-12]

## Write analyses to csv file.
write.csv(regulations_data_analysis, file = "regulations_data_analysis.csv")
