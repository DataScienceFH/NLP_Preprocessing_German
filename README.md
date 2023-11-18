# Natural Language Processing (NLP): General Preprocessing Pipeline (focussed on German)

## Description

This repository contains an R Markdown script designed for preprocessing German chat messages for Natural Language Processing (NLP) applications. The script provides a comprehensive approach to cleaning, normalizing, and preparing German text data, making it suitable for a variety of NLP tasks such as sentiment analysis, topic modeling, and language processing.
Input

The script processes a primary input file:

    your_input_TXT_file

where every line contains a document (string).

Additionally, it utilizes:

    NLP_Custom_German_StopWords.txt
    
, a file containing custom German stop words that have been derived from prior chat data analysis for more refined text processing.

## Output

The script generates two primary outputs:

    your_output_TXT_file
    
, a text file with preprocessed and cleaned chat messages, and

    your_dictionary_file

, a file listing sorted (and optionally unique) words extracted from the processed text, serving as a dictionary.

## Main Operations

The script executes several key operations:

- Library Integration: Utilizes the tm (text mining) and udpipe (language processing) libraries.
- Text Preprocessing:
   - UDpipe Model Setup: Employs a German language model from UDpipe for lemmatization.
   - Custom Stop Word Processing: Incorporates a user-defined stop word list.
   - Text Cleaning and Normalization: Includes lemmatization, handling special characters and accents, and general text cleaning (removal of punctuation, numbers, case normalization).
   - Corpus Creation and Modification: Transforms the cleaned text into a corpus, followed by stop word removal, stemming, and whitespace reduction.
   - Empty Message Removal: Detects and discards empty messages post-processing.
   - Output Generation: The cleaned and processed text is saved to an output file.

- Dictionary Creation:
   - Processes the cleaned text to extract individual words.
   - Sorts the words alphabetically and removes duplicates if needed.
   - Compiles the words into a dictionary file.

## Usage

This R Markdown script is particularly designed for individuals new to Natural Language Processing (NLP), focusing on preprocessing German chat messages. It provides an accessible starting point for those looking to understand and implement basic NLP preprocessing techniques.

### Preliminary Setup

Before executing the script, users must set the working directory <your_working_dir> to the location where their files and the custom stop word list are stored. Furthermore, users must specify the filenames for the input and output text files (<your_input_TXT_file> and <your_output_TXT_file>, respectively).

### Adaptability to Other Languages

While the script is tailored for German text data, it can be adapted to other languages with the following modifications:

- UDpipe Model: Replace the German UDpipe model with the appropriate model for the target language. This model is essential for accurate lemmatization specific to that language.
- Custom Stop Words List: Create or use an existing stop words list for the target language. This list should be in a text file and specified in the script.
- tm Package Settings: Adjust the stop word and stemming language settings in the tm package functions to match the target language. This includes changing parameters in removeWords (for stop words) and stemDocument (for stemming) to align with the new language.

By making these adjustments, the script can be effectively used for preprocessing chat messages in languages other than German, making it a versatile tool for NLP beginners working with various linguistic datasets.
