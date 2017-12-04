library(tm)
library(qdap)
library(stringr)

remove_links <- function(string) gsub('? http.*\\S', '', string)

# custom, keeps # and @ for twitter purposes
drop_punc <- function(string) gsub("[^[:alnum:][:space:]]", "", string)

# run this after drop_punc because it uses underscores
group_phrases <- function(string) {
  text <- gsub("pro? life", "prolife", string)
  text <- gsub("pro? choice", "prochoice", text)
  text <- gsub("grass? roots", "grassroots", text)
  text <- gsub("alt? right", "altright", text)
  text <- gsub("fake? news", "fakenews", text)
  text <- gsub("gun? control", "guncontrol", text)
  text <- gsub("make america great again", "maga", text)
  text <- gsub("health?.care", "healthcare", text)
  text
}

# cleaning functions
tweet_df$text <- gsub("&amp;", "and", tweet_df$text) %>%
  remove_links() %>%
  replace_contraction() %>%
  drop_punc() %>%
  tolower() %>%
  group_phrases() %>%
  removeWords(c(stopwords("en"),
                tolower(state.name), tolower(state.abb),
                "congress", "senate", "house")) %>%
  removeNumbers() %>%
  stripWhitespace()


completion_corpus <- VCorpus(DataframeSource(tweet_df))
text_stemmed <- lapply(tweet_df$text, stemDocument)
tweet_df$text <- unlist(text_stemmed)

clean.text <- function(some_txt) {
  some_txt = gsub("&amp\\.", "", some_txt)
  some_txt = gsub("@", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  
  # define "tolower error handling" function
  try.tolower = function(x){
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y)
  }
  some_txt = sapply(some_txt, try.tolower)
  some_txt = some_txt[some_txt != ""]
  names(some_txt) = NULL
  return(some_txt)
}

tweet_df$text <- clean.text(tweet_df$text)
completion_corpus <- VCorpus(DataframeSource(tweet_df))
text_stemmed <- lapply(tweet_df$text, stemDocument)
tweet_df$text <- unlist(text_stemmed)
completed_stems <- stemCompletion(tweet_df$text, completion_corpus)
stemmed_corpus <- VCorpus(VectorSource(tweet_df$text))
library(SnowballC)
tweet_tdm <- TermDocumentMatrix(stemmed_corpus)
tweet_count_df <- data.frame(as.matrix(tweet_tdm))
