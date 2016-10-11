# Word prediction using n-grams from a training corpus

library(stringr)
library(RSQLite)
library(magrittr)
library(tm)


ngram_backoff <- function(raw, db) {
  
  max = 3  # max n-gram - 1
  
  # prepare input by stripping whitespace, numbers,
  # capitalization, and punctuation
  sentence <- tolower(raw) %>%
    removePunctuation %>%
    removeNumbers %>%
    stripWhitespace %>%
    str_trim %>%
    strsplit(split=" ") %>%
    unlist
  
  for (i in min(length(sentence), max):1) {
    gram <- paste(tail(sentence, i), collapse=" ")
    sql <- paste("SELECT word, freq FROM NGram WHERE ", 
                 " pre=='", paste(gram), "'",
                 " AND n==", i + 1, " LIMIT 5", sep="")
    res <- dbSendQuery(conn=db, sql)
    predicted <- dbFetch(res, n=-1)
    names(predicted) <- c("Probable Word", "Freq. in Training Corpus")
    print(predicted)
    
    if (nrow(predicted) > 0) return(predicted)
  }
  
  return("Not enough data in the corpus to predict the next word using backoff.")
}