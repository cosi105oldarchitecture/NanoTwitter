# Represents the db's Tweet table
class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :tweet_tags
  has_many :hashtags, through: :tweet_tags
  has_many :mentions
  has_many :timeline_pieces
end
