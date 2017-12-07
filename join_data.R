library(jsonlite)
library(dplyr)
unzip("DataCollection/10001_house.zip", exdir = "DataCollection")
unzip("DataCollection/50000_senate.zip", exdir = "DataCollection")
tweet_file <- "DataCollection/sample1.json"
senate_file <- "DataCollection/senate_sample1.json"
tweet_list <- fromJSON(tweet_file, simplifyVector = FALSE)
senate_list <- fromJSON(senate_file, simplifyVector = FALSE)
# Each [[i]] is a tweet

tweet_df <- matrix(ncol = 6, nrow = 0)
senate_df_1 <- tweet_df
senate_df_2 <- tweet_df
senate_df_3 <- tweet_df
senate_df_4 <- tweet_df
senate_df_5 <- tweet_df
for (tweet in tweet_list) {
  tweet_df <- rbind(tweet_df, c(tweet$id_str,
                    tweet$full_text,
                    tweet$created_at,
                    tweet$user$screen_name,
                    tweet$favorite_count,
                    tweet$retweet_count))
}
for (tweet in senate_list[1:10000]) {
  senate_df_1 <- rbind(senate_df_1, c(tweet$id_str,
                                tweet$full_text,
                                tweet$created_at,
                                tweet$user$screen_name,
                                tweet$favorite_count,
                                tweet$retweet_count))
}
for (tweet in senate_list[10001:20000]) {
  senate_df_2 <- rbind(senate_df_2, c(tweet$id_str,
                                   tweet$full_text,
                                   tweet$created_at,
                                   tweet$user$screen_name,
                                   tweet$favorite_count,
                                   tweet$retweet_count))
}
for (tweet in senate_list[20001:30000]) {
  senate_df_3 <- rbind(senate_df_3, c(tweet$id_str,
                                      tweet$full_text,
                                      tweet$created_at,
                                      tweet$user$screen_name,
                                      tweet$favorite_count,
                                      tweet$retweet_count))
}
for (tweet in senate_list[30001:40000]) {
  senate_df_4 <- rbind(senate_df_4, c(tweet$id_str,
                                      tweet$full_text,
                                      tweet$created_at,
                                      tweet$user$screen_name,
                                      tweet$favorite_count,
                                      tweet$retweet_count))
}
for (tweet in senate_list[40001:50000]) {
  senate_df_5 <- rbind(senate_df_5, c(tweet$id_str,
                                      tweet$full_text,
                                      tweet$created_at,
                                      tweet$user$screen_name,
                                      tweet$favorite_count,
                                      tweet$retweet_count))
}

tweet_df <- data.frame(rbind(tweet_df,
                             senate_df_1,
                             senate_df_2,
                             senate_df_3,
                             senate_df_4,
                             senate_df_5))
colnames(tweet_df) <- c("doc_id", "text", "timestamp","username", "favorites","retweets")
# saved_tweet_df <- tweet_df

rm(senate_df_1,
   senate_df_2,
   senate_df_3,
   senate_df_4,
   senate_df_5,
   senate_list,
   tweet_list,
   tweet)
