library(htmltab)
library(dplyr)

tweet_url <- "https://www.socialseer.com/resources/us-senator-twitter-accounts/"
senate_twitters <- htmltab(doc = tweet_url, which = '//*[@id="post-109"]/div/table[1]/tbody') %>%
  select(1:3) %>%
  filter(Senator != "Saxby Chambliss")
colnames(senate_twitters) <- c("state", "senator", "twitter")
rownames(senate_twitters) <- NULL
senate_twitters$twitter <- sub("@", "", senate_twitters$twitter)
senate_twitters[34, 3] <- "RandPaul"
senate_twitters[58, 3] <- "SenatorHassan"
senate_twitters[79, 3] <- "LindseyGrahamSC"
senate_twitters[86, 3] <- "tedcruz"
senate_twitters[90, 3] <- "SenSanders"
senate_twitters$party <- factor(c(1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,
                           0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,1,3,1,0,0,
                           0,0,0,0,0,0,1,1,0,1,1,0,1,1,0,1,0,0,0,0,
                           0,0,0,0,1,1,0,1,0,1,1,1,0,0,0,1,0,0,1,1,
                           1,1,1,1,1,1,1,1,0,3,0,0,0,0,1,0,0,1,1,1),
                           levels = c("0", "1", "3"),
                           labels = c("Democrat", "Republican", "Independent"))

twitter_data <- data.frame(matrix(ncol = 6, nrow = 0))
x <- c("id", "created_at", "text","user","favorite_count","retweet_count")
colnames(twitter_data) <- x

for (handle in senate_twitters$twitter) {
  file <- paste0("SenateData/", handle, "_tweets.csv")
  data <- read.csv(file)
  twitter_data <- rbind(twitter_data, data)
}
write.csv(twitter_data, file = "full_senate.csv", row.names = FALSE)
