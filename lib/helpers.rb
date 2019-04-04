# Misc. helper methods for NanoTwitter

# Sets local env configurations if applicable
def set_env_configs
  return false if Sinatra::Base.production?

  require 'dotenv'
  Dotenv.load 'config/local_vars.env'
  require 'pry-byebug'
end

# Adds tweet & associated records to db.
def set_new_tweet(author_id, author_handle, tweet_body)
  unless tweet_body.nil?
    new_tweet = Tweet.create(
      author_id: author_id,
      author_handle: author_handle,
      body: tweet_body,
      created_on: DateTime.now
    )
    parsed_tweet = parse_tweet(tweet_body)
    set_hashtags(new_tweet, parsed_tweet[:hashtags])
    set_mentions(new_tweet, parsed_tweet[:mentions])
  end
  new_tweet
end

# Extracts mentions and hashtags from the body of a tweet
def parse_tweet(tweet_body)
  tokens = tweet_body.split(/[.,\/!$%\^&\*;:{}=\-_`~()\?\s]/)
  mentions = tokens.select { |token| token[0] == '@' }
  hashtags = tokens.select { |token| token[0] == '#' }
  {
    body: tweet_body,
    mentions: mentions,
    hashtags: hashtags
  }
end

# Represents in db any hashtags extracted from tweet
def set_hashtags(tweet, hashtags)
  hashtags.each do |tag_text|
    Hashtag.find_or_create_by(name: tag_text).tweets << tweet
  end
end

# Represents in db any mentions extracted from tweet
def set_mentions(tweet, mentions)
  mentions.each do |handle|
    mentioned_user = User.find_by(handle: handle)
    mentioned_user.mentioned_tweets << tweet unless mentioned_user.nil?
  end
end

# Gets env-specific Redis object
def get_redis_object
  redis = nil
  if Sinatra::Base.production?
    configure do
      uri = URI.parse(ENV['REDISTOGO_URL'])
      redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
    end
  else
    redis = Redis.new
  end
  redis.flushall
  redis
end

# Returns cached timeline HTML on cache hit,
# otherwise generates, caches, & returns timeline HTML.
def check_timeline_cache
  user = session[:user]
  redis_key = "#{user.id}:timeline_html"
  return REDIS.get(redis_key) if REDIS.exists(redis_key)

  timeline_size = 0
  user.timeline_tweets.each do |tweet|
    puts "1"
    REDIS.hmset(
      "#{user.id}:#{timeline_size += 1}", # Key of Redis hash
      'id', tweet.id,                     # First key-value pair
      'body', tweet.body,
      'created_on', tweet.created_on,
      'author_handle', tweet.author_handle
    )
  timeline_html = ''
    user.timeline_tweets.order(created_on: :desc).each do |t|
      timeline_html << "<li>#{t.body}<br/>-#{t.author_handle} at #{t.created_on}</li>"
    end
  end
  REDIS.set(redis_key, timeline_html)
  timeline_html
end
