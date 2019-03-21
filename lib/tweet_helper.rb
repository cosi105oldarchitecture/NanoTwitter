def new_tweet_fanout(tweet_id)
  Thread.new do
    HTTParty.post("#{ENV['FANOUT_URL']}/new_tweet/#{tweet_id}")
  end
end
