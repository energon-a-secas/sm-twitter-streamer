require_relative 'tools/search_tweets'

client = SearchTweets.new
client.stream_tweets('2546757852', 'http') # Descuentos Rata
