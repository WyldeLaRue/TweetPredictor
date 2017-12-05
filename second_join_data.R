library(dplyr)

party_id <- c("Democrat","Republican","Republican","Democrat","Democrat",
           "Democrat","Democrat","Republican","Democrat","Republican",
           "Democrat","Republican","Democrat","Democrat","Democrat",
           "Republican","Republican","Republican","Democrat","Republican",
           "Democrat","Republican","Democrat","Republican","Democrat",
           "Democrat","Republican","Democrat","Republican","Democrat",
           "Republican","Democrat","Republican","Democrat","Republican",
           "Republican","Democrat","Democrat","Republican","Republican",
           "Democrat","Republican","Republican","Democrat","Republican",
           "Republican","Democrat","Republican","Republican","Democrat",
           "Democrat","Democrat","Democrat","Democrat","Republican",
           "Democrat","Republican","Republican","Democrat")

congress_df_short <- congress_df %>%
  select(party_id, twitter) %>%
  rbind(data.frame(party_id, twitter = missing))

full_data <- inner_join(congress_df_short, scaled_freq, by = c("twitter" = "username"))

