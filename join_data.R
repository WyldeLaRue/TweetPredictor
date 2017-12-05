library(jsonlite)
library(dplyr)
tweet_file <- "DataCollection/sample1.json"
tweet_list <- fromJSON(tweet_file, simplifyVector = FALSE)
# Each [[i]] is a tweet

tweet_df <- matrix(ncol = 6, nrow = 0)
for (tweet in tweet_list) {
  tweet_df <- rbind(tweet_df, c(tweet$id_str,
                    tweet$full_text,
                    tweet$created_at,
                    tweet$user$screen_name,
                    tweet$favorite_count,
                    tweet$retweet_count))
}
tweet_df <- data.frame(tweet_df) # change "smart quotes" to regular single quote
colnames(tweet_df) <- c("doc_id", "text", "timestamp","username", "favorites","retweets")
# saved_tweet_df <- tweet_df

congress_df <- read.csv("legislators-current.csv") %>%
  select(last_name, first_name, type, state, party, twitter)

missing <- unique(tweet_df$username)[-which(unique(tweet_df$username) %in% congress_df$twitter)]

fake_data <- data.frame(id = tweet_df$doc_id,
                        fake_news = runif(10001),
                        maga = runif(10001),
                        health_care = runif(10001),
                        gun_control = runif(10001))
