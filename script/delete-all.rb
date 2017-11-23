require "twitter"
require "pry"

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV.fetch("TWEET_DELETER_CONSUMER_KEY", "OOPS")
  config.consumer_secret = ENV.fetch("TWEET_DELETER_CONSUMER_SECRET", "OOPS")
  config.access_token = ENV.fetch("TWEET_DELETER_ACCESS_TOKEN", "OOPS")
  config.access_token_secret = ENV.fetch("TWEET_DELETER_ACCESS_TOKEN_SECRET", "OOPS")
end

retention_date = Time.new(Time.now.year,1,1) # retain all tweets posted this calendar year

tweet_counter = 0
delete_counter = 0

options = {count: 200, include_rts: true}
tweets = client.user_timeline(options)

while tweets.any? do
  tweets.each do |tweet|
    tweet_counter +=1
    puts "--------------------"
    puts "#{tweet.id} -- #{tweet.created_at.to_date} -- #{tweet.text}"

    if !tweet.favorited? && tweet.created_at < retention_date
      delete_counter +=1
      client.destroy_tweet(tweet.id)
    end
  end

  sleep 1
  options[:max_id] = tweets.last.id - 1
  tweets = client.user_timeline(options)
end

puts "DELETED #{delete_counter} / #{tweet_counter} TWEETS."
