# Utility Functions
library(RWeka)
library(magrittr)
library(data.table)

# takes a vector of documents as input and converts it into a tm Corpus
getCorpus <- function(v) {

  corpus <- VCorpus(VectorSource(v))
  corpus <- tm_map(corpus, stripWhitespace)  # remove whitespace
  corpus <- tm_map(corpus, content_transformer(tolower))  # lowercase all
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus
}

# take samples
samplefile <- function(filename, fraction) {
  system(paste("perl -ne 'print if (rand() < ",
               fraction, ")'", filename), intern=TRUE)
}


# remove repeated spaces and split the strings,
# add spaces before & after punctuation,
tokenize <- function(v) {

  gsub("([^ ])([.?!&])", "\\1 \\2 ", v)   %>%
    gsub(pattern=" +", replacement=" ")     %>%
    strsplit(split=" ") %>%
    unlist
}

# Add to n-gram data.table pre (before word) and cur (word itself)
processGram <- function(dt) {

  dt[, c("pre", "cur"):=list(unlist(strsplit(word, "[ ]+?[a-z]+$")),
                             unlist(strsplit(word, "^([a-z]+[ ])+"))[2]),
     by=word]
}

bulk_insert <- function(sql, key_counts)
{
  dbBegin(db)
  dbGetPreparedQuery(db, sql, bind.data = key_counts)
  dbCommit(db)
}

# Takes tm's TermDocumentMatrix and puts it into frequency data.table
tdmToFreq <- function(tdm) {

  freq <- sort(row_sums(tdm, na.rm=TRUE), decreasing=TRUE)
  word <- names(freq)
  data.table(word=word, freq=freq)
}


UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
PentagramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
