require 'twitter'
require_relative 'notify_tweets'

# Class for reading all new tweets or interactions that involves an specific account
class SearchTweets
  include Announcement

  def initialize(test: false, c_key: ENV['TWITTER_C_KEY'], c_secret: ENV['TWITTER_C_SECRET'], a_token: ENV['TWITTER_A_TOKEN'], a_secret: ENV['TWITTER_A_SECRET'])
    @stream_test = test
    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = c_key
      config.consumer_secret     = c_secret
      config.access_token        = a_token
      config.access_token_secret = a_secret
    end
  end

  def check_tweet(pattern, filter = '^(RT @|@)')
    @data_tweet.match(/#{pattern}/i) && @data_tweet.match(filter).nil? ? true : false
  end

  def stream_tweets(account, pattern = '(.*)')
    @client.filter(follow: account) do |tweet|
      sleep 1
      @data_tweet = tweet.text

      if @stream_test
        tweet.text
        exit
      else
        if tweet.user.id == account.to_i && check_tweet(pattern)
          chat_groups(tweet.url)
        end
      end
    end
  rescue JSON::ParserError, Twitter::Streaming::DeletedTweet => e
    print "WARN: #{e.message}\n"
    sleep 40
    retry
  rescue Twitter::Error::TooManyRequests => e
    sleep e.rate_limit.reset_in + 10
    retry
  # This one is because there are many unknown errors
  rescue StandardError => e
    print "WARN: #{e.message}\n"
    sleep 20
    retry
  end
end
