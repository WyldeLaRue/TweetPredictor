library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

tidy_freqs <- tidy_tweets %>%
  filter(word %in% colnames(full_data)) %>%
  inner_join(congress_df_short, by = c("username" = "twitter"))
tidy_freqs <- tidy_freqs %>%
  mutate(total = ifelse(party_id == "Democrat",
                        sum(tidy_freqs$party_id == "Democrat"),
                        sum(tidy_freqs$party_id == "Republican"))) %>%
  group_by(party_id, word) %>%
  summarize(n = n(),
            total = mean(total),
            prop = n/total) %>%
  select(party_id, word, prop) %>% 
  spread(party_id, prop, fill = 0)

tidy_freqs_user_tags <- filter(tidy_freqs, str_detect(word, "^@"))
tidy_freqs_hash_tags <- filter(tidy_freqs, str_detect(word, "^#"))
tidy_freqs_no_tags <- filter(tidy_freqs, !str_detect(word, "^@|^#"))

# all words
ggplot(tidy_freqs, aes(Democrat, Republican)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE,
            hjust = "inward", vjust = "inward") +
  scale_x_log10(labels = percent_format(), expand = c(.1,.1)) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  title"All Terms Used, by Political Party")

#user tags
ggplot(tidy_freqs_user_tags, aes(Democrat, Republican)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE,
            hjust = "inward", vjust = "inward") +
  scale_x_log10(labels = percent_format(), expand = c(.1,.1)) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  title("Tagged Users, by Political Party")

# hashtags
ggplot(tidy_freqs_hash_tags, aes(Democrat, Republican)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE,
            hjust = "inward", vjust = "inward") +
  scale_x_log10(labels = percent_format(), expand = c(.1,.1)) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  title("Hashtags, by Political Party")

# regular words
ggplot(tidy_freqs_no_tags, aes(Democrat, Republican)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE,
            hjust = "inward", vjust = "inward") +
  scale_x_log10(labels = percent_format(), expand = c(.1,.1)) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  title("Regular Words Used, by Political Party")


log_ratios <- tidy_freqs %>%
  mutate_if(is.numeric, funs((. + 1) / sum(. + 1))) %>%
  mutate(logratio = log(Democrat / Republican)) %>%
  arrange(desc(logratio))

head(arrange(log_ratios, abs(logratio)))
# all terms
log_ratios %>%
  group_by(logratio < 0) %>%
  top_n(15, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col() +
  coord_flip() +
  ylab("log odds ratio (Democrat/Repubican)") +
  ggtitle("Highest Usage Difference, by Party - All Terms") +
  scale_fill_manual(name = "", labels = c("Democrat", "Republican"), values=c("#00BFC4","#F8766D"))
# user tags
log_ratios %>%
  filter(str_detect(word, "^@")) %>%
  group_by(logratio < 0) %>%
  top_n(10, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col() +
  coord_flip() +
  ylab("log odds ratio (Democrat/Repubican)") +
  ggtitle("Highest Usage Difference, by Party - User Tags") +
  scale_fill_manual(name = "", labels = c("Democrat", "Republican"), values=c("#00BFC4","#F8766D"))
#hashtags
log_ratios %>%
  filter(str_detect(word, "^#")) %>%
  group_by(logratio < 0) %>%
  top_n(15, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col() +
  coord_flip() +
  ylab("log odds ratio (Democrat/Repubican)") +
  ggtitle("Highest Usage Difference, by Party - Hashtags") +
  scale_fill_manual(name = "", labels = c("Democrat", "Republican"), values=c("#00BFC4","#F8766D"))

# regular terms
log_ratios %>%
  filter(!str_detect(word, "^#|^@")) %>%
  group_by(logratio < 0) %>%
  top_n(15, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col() +
  coord_flip() +
  ylab("log odds ratio (Democrat/Repubican)") +
  ggtitle("Highest Usage Difference, by Party - Regular Terms") +
  scale_fill_manual(name = "", labels = c("Democrat", "Republican"), values=c("#00BFC4","#F8766D"))
