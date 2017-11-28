#!/usr/bin/env python
# encoding: utf-8

import tweepy #https://github.com/tweepy/tweepy
import csv

#Twitter API credentials
consumer_key = "p92MsZxADddOs9DQuERrNoMh2"
consumer_secret = "Jq0XFjnTChnh9rUIXOc1xpySZ2Ws5zroU4cXm0QrMbObnPvGwc"
access_key = "837127115636150273-9fXL0rJ1cEVmiioSaRaOBPokj5HURzW"
access_secret = "FMSAU6rXs4zbCnAMZUrJ48WxQNiYztyAXz4lHVsMuSAjg"


def get_all_tweets(screen_name):
	#Twitter only allows access to a users most recent 3240 tweets with this method
	
	#authorize twitter, initialize tweepy
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_key, access_secret)
	api = tweepy.API(auth)
	
	#initialize a list to hold all the tweepy Tweets
	alltweets = []	
	
	#make initial request for most recent tweets (200 is the maximum allowed count)
	new_tweets = api.user_timeline(screen_name = screen_name,count=200)
	
	#save most recent tweets
	alltweets.extend(new_tweets)
	
	#save the id of the oldest tweet less one
	oldest = alltweets[-1].id - 1
	
	#keep grabbing tweets until there are no tweets left to grab
	while len(new_tweets) > 0:
		print("getting tweets before {}".format(oldest))
		
		#all subsiquent requests use the max_id param to prevent duplicates
		new_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest)
		
		#save most recent tweets
		alltweets.extend(new_tweets)
		
		#update the id of the oldest tweet less one
		oldest = alltweets[-1].id - 1
		
		print("...{} tweets downloaded so far".format(len(alltweets)))
	
	#transform the tweepy tweets into a 2D array that will populate the csv	
	outtweets = [[tweet.id_str, tweet.created_at, tweet.text.encode("utf-8"), tweet.user.screen_name, tweet.favorite_count, tweet.retweet_count] for tweet in alltweets]
	
	#write the csv	
	with open('{}_tweets.csv'.format(screen_name), 'w') as f:
		writer = csv.writer(f)
		writer.writerow(["id","created_at","text", "user", "favorite_count", "retweet_count"])
		writer.writerows(outtweets)
	
	pass
