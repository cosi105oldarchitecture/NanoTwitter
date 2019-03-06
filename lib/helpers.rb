# Misc. helper methods for NanoTwitter

# Adds tweet & associated records to db.
def set_new_tweet(author_id, tweet_body)
  unless tweet_body.nil?
    new_tweet = Tweet.create(author_id: author_id, body: tweet_body, created_on: DateTime.now)
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
def set_hashtag(tweet, hashtags)
  hashtags.each do |tag_text|
    # If tag doesn't already exist, create it.
    tag = Hashtag.find_by(name: tag_text) || Hashtag.create(name: tag_text)
    TweetTag.create(tweet_id: tweet.id, hashtag_id: tag.id)
  end
end

# Represents in db any mentions extracted from tweet
def set_mention(tweet, mentions)
  mentions.each do |name|
    # Do users mention one another by full name? How do we hadle spaces?
    mentioned_user = User.find_by(name: name)
    # If mentioned user exists, create mention
    mentioned_user ? Mention.create(tweet_id: tweet.id, mentioned_user_id: mentioned_user.id) : nil
  end
end
