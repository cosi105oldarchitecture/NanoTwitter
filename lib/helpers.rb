# Misc. helper methods for NanoTwitter

# Adds tweet & associated records to db.
def set_new_tweet(author_id, author_handle, tweet_body)
  unless tweet_body.nil?
    new_tweet = Tweet.create(author_id: author_id, author_handle: author_handle, body: tweet_body, created_on: DateTime.now)
    parsed_tweet = parse_tweet(tweet_body)
    set_hashtags(new_tweet, parsed_tweet[:hashtags])
    set_mentions(new_tweet, parsed_tweet[:mentions])
  end
  parsed_tweet
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
