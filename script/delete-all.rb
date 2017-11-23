require "twitter"
require "pry"
#require 'active_support/core_ext/object/blank'

#
# CONFIGURE AND INITIALIZE API CLIENT
#

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV.fetch("TWEET_DELETER_CONSUMER_KEY", "OOPS")
  config.consumer_secret = ENV.fetch("TWEET_DELETER_CONSUMER_SECRET", "OOPS")
  config.access_token = ENV.fetch("TWEET_DELETER_ACCESS_TOKEN", "OOPS")
  config.access_token_secret = ENV.fetch("TWEET_DELETER_ACCESS_TOKEN_SECRET", "OOPS")
end

#
# LOOP THROUGH ALL TWEETS
#
# adapted from https://github.com/sferik/twitter/blob/master/examples/AllTweets.md

options = {count: 200, include_rts: true}

tweets = client.user_timeline(options)

while tweets.any? do
  tweets.each do |tweet|
    puts "#{tweet.id} -- #{tweet.created_at.to_date} -- #{tweet.text}"
  end

  puts "--------------------"

  sleep 1

  options[:max_id] = tweets.last.id - 1
  tweets = client.user_timeline(options)
end
