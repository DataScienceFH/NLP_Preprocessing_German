# Packages

library(tm)
library(udpipe)
knitr::opts_chunk$set(echo = TRUE)

# Preprocessing

setwd("your_working_dir")
input_file <- "your_input_TXT_file"

# Either download udpipe model
dl <- udpipe_download_model(language = "german")
udmodel_german <- udpipe_load_model(file = dl$file_model)
# or load model from file
udmodel_german <- udpipe_load_model(file = "german-gsd-ud-2.5-191206.udpipe")

# Function to replace tokens with lemmas
replace_with_lemmas <- function(text, model) {
  annotation <- udpipe_annotate(model, x = text)
  annotation <- as.data.frame(annotation)
  
  # Replace tokens with lemmas, or keep the original token if lemma is not available
  tokens_with_lemmas <- ifelse(is.na(annotation$lemma), annotation$token, annotation$lemma)
  
  # Rebuild the string
  return(paste(tokens_with_lemmas, collapse = " "))
}

# Handle German Special Characters and Accents
replaceAccentedVowels <- function(corpus, mapping) {
  # Content transformer function
  replacePattern <- content_transformer(function(x, pattern, replacement) {
    gsub(pattern, replacement, x, fixed = TRUE)
  })
  
  # Loop through each mapping and apply the transformation
  for (i in 1:nrow(mapping)) {
    corpus <- tm_map(corpus, replacePattern, mapping$Original[i], mapping$Replacement[i])
  }
  
  return(corpus)
}

accent_mapping <- data.frame(
  Original = c("ä", "ö", "ü", "ß", "é", "è", "à", "å", "ê", "î", "ô", "ù", "ç", "á", "ì", "í", "ò", "ó", "ú"),
  Replacement = c("ae", "oe", "ue", "ss", "e", "e", "a", "a", "e", "i", "o", "u", "c", "a", "i", "i", "o", "o", "u")
)

# Handle Special Pattern
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})
myPatterns <- c("/", "¤", "½", "°", "®", "©", "×", "²", "€", "›", "‹", "’", "´", "¯", "¨", "¦", "¡", "„",    " ", "–", "—", "–", "<", ">", ":", "'", "\n", "-", "«", "»", "µ", " ", "•", "‚", "‘", "“", "…", "'", "'", ",", "”", "§", "¿", "·", "†", "¸", "£", "¥", "±", "÷", "¹", "¬", "³")

# Reading the TXT file with the text to be processed
messages <- readLines(con = input_file, encoding = "UTF-8")
cleaned_messages <- messages

# Remove emoticons
cleaned_messages <- iconv(cleaned_messages, "UTF-8", sub="")

# Processing the text with tm package
Sys.setlocale("LC_CTYPE", "german")

corpus <- VCorpus(VectorSource(cleaned_messages))
for (i in 1:length(myPatterns)) {
  corpus <- tm_map(corpus, toSpace, myPatterns[i])
}
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- replaceAccentedVowels(corpus, accent_mapping)

# Update the DataFrame with cleaned text
for (i in 1:length(corpus)) {
  cleaned_messages[i] <- corpus[[i]]$content
}

# Apply the function to each string in the vector
lemmatized_messages <- sapply(cleaned_messages, replace_with_lemmas, model = udmodel_german, USE.NAMES = FALSE)

corpus <- VCorpus(VectorSource(lemmatized_messages))
corpus <- tm_map(corpus, removeWords, stopwords("german"))  
corpus <- replaceAccentedVowels(corpus, accent_mapping)
corpus <- tm_map(corpus, stemDocument, language = "german")
corpus <- tm_map(corpus, stripWhitespace)

# Update the DataFrame with cleaned text
for (i in 1:length(corpus)) {
  cleaned_messages[i] <- corpus[[i]]$content
}

# Remove empty messages
empty_message_count <- 0
for (i in length(cleaned_messages):1) {
  if (cleaned_messages[i] == "") {
    cleaned_messages <- cleaned_messages[-i,]
    empty_message_count <- empty_message_count + 1
  }
}
print(paste0("Empty messages removed: ", empty_message_count))

# Save the processed data
output_file <- "your_output_TXT_file"

# Write the vector to a file
writeLines(cleaned_messages, con = output_file)

# Read the file
file_content <- readLines("your_output_TXT_file")

# Combine all lines into one big text string (if your file has multiple lines)
big_text <- paste(file_content, collapse = " ")

# Split the text into words
words <- unlist(strsplit(big_text, split = "\\s+"))

# Remove empty elements (if any)
words <- words[words != ""]

# Sort the words alphabetically
sorted_words <- sort(words)

# Optionally, remove duplicates if you want unique words only
sorted_words <- unique(sorted_words)

# Print the sorted words or write them to a file
writeLines(sorted_words, "your_dictionary_file")
