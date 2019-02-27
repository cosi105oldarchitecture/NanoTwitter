# Represents the db's Hashtag table
class Hashtag < ActiveRecord::Base
  has_many :tweet_tags
end
